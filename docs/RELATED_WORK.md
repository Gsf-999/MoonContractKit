# Related Work

MoonContractKit is a contract-governance library, not a general schema parser.
It focuses on compatibility decisions and release gates.

## Mature references

- Confluent Schema Registry popularized compatibility checks for event schema
  evolution. MoonContractKit follows the same idea at a small MoonBit library
  level: compare old/new contracts and block breaking changes before release.
- OpenAPI and AsyncAPI define service and event interfaces. MoonContractKit does
  not replace those specifications; it provides a compact MoonBit kernel that
  can be used under an adapter for API or event contract workflows.
- Pact-style consumer-driven contract testing shows the value of preventing
  producer changes from breaking consumers. MoonContractKit models the same
  concern as typed field compatibility and observed-payload validation.

## Difference from schema diff tools

A schema diff tool usually tells users what changed. MoonContractKit answers the
release question:

> Can this contract change be shipped safely for existing consumers?

For that reason the library includes change classification, runtime payload
validation, PII review warnings, gate decisions, and JSON reports.

## Boundary

MoonContractKit deliberately does not:

- parse every JSON Schema/OpenAPI/AsyncAPI feature;
- connect to a registry server;
- generate SDKs;
- store contracts remotely.

Instead, it provides a MoonBit-native decision core that can be embedded into
CI, code generation, event testing, SDK release checks, or data platform tools.
