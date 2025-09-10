# Cert Registry Smart Contract

A decentralized certificate authority (CA) smart contract for the Stacks blockchain, written in Clarity.

## Overview

This smart contract enables secure management of digital certificates on-chain. It allows an admin to issue, revoke, and verify certificates for principals (users or entities), with robust input validation and error handling.

## Features

- **Issue Certificates:** Admins can issue certificates to principals with custom data (e.g., hash or URI).
- **Revoke Certificates:** Admins can revoke certificates, marking them as invalid.
- **Transfer Admin Rights:** Admin privileges can be transferred to another principal.
- **Certificate Verification:** Anyone can check if a principal has a valid certificate.
- **Input Validation:** Ensures only valid principals and certificate data are accepted.
- **Error Handling:** Standardized error codes for unauthorized actions, invalid input, and certificate status.

## Usage

Deploy this contract on the Stacks blockchain to manage certificates for users or entities in a decentralized manner. Functions are available for both admin and public interactions, with clear separation of responsibilities and robust validation.

## Project Structure

- `contracts/cert-registry.clar` — Main smart contract source code
- `tests/` — Test files (linguist-vendored)
- `.gitattributes` — Git configuration for linguist and line endings

## Getting Started

1. Clone the repository.
2. Deploy the contract using [Clarinet](https://docs.stacks.co/docs/clarity/clarinet/).
3. Run tests to verify contract functionality.
