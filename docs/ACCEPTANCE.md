# Acceptance Notes

MoonContractKit targets data contract governance for MoonBit applications.

## Implemented scope

- Field types, contract fields, and versioned data contracts.
- Compatibility comparison between old and new contracts.
- Breaking/risky/additive change classification.
- PII classification change detection.
- Observed payload validation.
- Strict gate decision for CI and release workflows.
- JSON reports, CLI demo, tests, related-work notes, and application material.

## Reviewable value

The project is useful when MoonBit services or SDKs publish structured data:
events, API payloads, analytics rows, telemetry records, or exported reports.
It prevents silent contract drift by producing deterministic compatibility and
payload validation reports.

## Local verification

```bash
moon fmt
moon info
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
moon run cmd/main
```
