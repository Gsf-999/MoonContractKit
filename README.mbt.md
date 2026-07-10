# MoonContractKit

MoonContractKit is a MoonBit foundation library for data contract
compatibility, payload validation, and release gates. It is designed for event
pipelines, SDKs, analytics exports, API payloads, and producer-consumer systems
that need to evolve data formats without silently breaking downstream users.

It is not a general JSON Schema implementation and does not bind to one storage
system, queue, or cloud provider. The core value is a deterministic MoonBit
decision layer:

- compare an old and new data contract;
- classify changes as additive, risky, or breaking;
- validate observed payload fields against the active contract;
- detect PII classification changes that require review;
- produce a strict gate decision for CI or release workflows;
- export stable JSON reports for dashboards, logs, and review bots.

```moonbit nocheck
let old_contract = user_created_v1()
let new_contract = user_created_v2_additive()
let compatibility = compare_contracts(old_contract, new_contract)
let validation = validate_payload(
  new_contract,
  [
    ObservedField::new("user_id", Text, true),
    ObservedField::new("created_at", Timestamp, true),
  ],
)
let gate = evaluate_contract_gate(
  strict_contract_gate(),
  compatibility,
  validation,
)

println(compatibility.to_json())
println(validation.to_json())
println(gate.to_json())
```

## Why this matters

In real systems, schema evolution fails in boring but expensive ways: a required
field is removed, a text id becomes an integer, a new required field breaks
older producers, or a field that used to be ordinary data is suddenly personal
data. MoonContractKit makes those changes visible before deployment.

## Core API

- `DataContract`: named versioned contract with field definitions.
- `ContractField`: field name, type, required flag, PII flag, and description.
- `compare_contracts`: old/new compatibility report.
- `validate_payload`: observed payload conformance report.
- `ContractGate`: release gate policy.
- `evaluate_contract_gate`: CI-friendly allow/warn/block decision.

## Mature references

MoonContractKit follows the contract-governance ideas seen in mature systems:

- Confluent Schema Registry compatibility checks for event producers and
  consumers.
- OpenAPI and AsyncAPI contract-first development for API and event interfaces.
- Pact-style consumer-driven contracts for preventing integration breakage.

The project keeps the MoonBit scope narrower: a backend-neutral compatibility
and gate kernel that can later be connected to JSON, message queues, OpenAPI,
AsyncAPI, or generated SDKs.

## Verification

```bash
moon fmt
moon info
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
moon run cmd/main
```
