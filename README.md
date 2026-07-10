# MoonContractKit

MoonBit data contract compatibility, payload validation, and CI release gate
primitives.

MoonContractKit helps MoonBit projects evolve event/API/data payloads safely.
It detects breaking schema changes, risky PII-classification changes, unexpected
payload fields, missing required fields, and type mismatches before a producer
or SDK release reaches users.

See [README.mbt.md](README.mbt.md) for package-facing documentation.

## Included

- Typed data contract model.
- Old/new compatibility report.
- Runtime payload validation report.
- Strict CI gate decision.
- JSON export, CLI demo, tests, CI, related-work notes, and application PDF.
