;; cert-authority.clar
;; Decentralized Certificate Authority (CA)
;; Simple, clear, and Clarinet-friendly.

(define-map certificates
  (tuple (subject principal))
  (tuple (data (buff 1024))
         (issued-at uint)
         (valid bool)
         (issuer principal)))

(define-data-var admin principal tx-sender)

;; Error codes
(define-constant ERR-UNAUTHORIZED u100)
(define-constant ERR-NOT_FOUND u102)
(define-constant ERR-ALREADY_REVOKED u104)
;; Added new error codes for input validation
(define-constant ERR-INVALID_PRINCIPAL u105)
(define-constant ERR-INVALID_DATA u106)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Internal helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-read-only (is-admin (caller principal))
  (is-eq caller (var-get admin)))

;; Added input validation helpers
(define-private (is-valid-principal (p principal))
  (not (is-eq p 'SP000000000000000000002Q6VF78)))

(define-private (is-valid-data (data (buff 1024)))
  (> (len data) u0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Admin functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Issue a certificate for `subject` with `data` (e.g. hash or URI).
(define-public (issue-certificate (subject principal) (data (buff 1024)))
  (begin
    (asserts! (is-admin tx-sender) (err ERR-UNAUTHORIZED))
    ;; Added input validation for subject and data
    (asserts! (is-valid-principal subject) (err ERR-INVALID_PRINCIPAL))
    (asserts! (is-valid-data data) (err ERR-INVALID_DATA))
    (map-set certificates
      (tuple (subject subject))
      (tuple (data data)
             (issued-at stacks-block-height)
             (valid true)
             (issuer tx-sender)))
    (ok true)))

;; Revoke a certificate
(define-public (revoke-certificate (subject principal))
  (begin
    (asserts! (is-admin tx-sender) (err ERR-UNAUTHORIZED))
    ;; Added input validation for subject
    (asserts! (is-valid-principal subject) (err ERR-INVALID_PRINCIPAL))
    (match (map-get? certificates (tuple (subject subject)))
      cert
        (begin
          (asserts! (get valid cert) (err ERR-ALREADY_REVOKED))
          (ok (map-set certificates
                (tuple (subject subject))
                (merge cert (tuple (valid false))))))
      (err ERR-NOT_FOUND))))

;; Transfer admin to another principal
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin tx-sender) (err ERR-UNAUTHORIZED))
    ;; Added input validation for new-admin
    (asserts! (is-valid-principal new-admin) (err ERR-INVALID_PRINCIPAL))
    (var-set admin new-admin)
    (ok true)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Read-only helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Get certificate info for `subject`
(define-read-only (get-certificate (subject principal))
  (map-get? certificates (tuple (subject subject))))

;; True if subject has a certificate and it's valid
(define-read-only (is-verified? (subject principal))
  (match (get-certificate subject)
    cert (get valid cert)
    false))
