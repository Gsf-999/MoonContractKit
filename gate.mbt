///|
pub(all) struct ContractGate {
  name : String
  block_breaking : Bool
  block_validation_errors : Bool
  warn_on_risky : Bool
} derive(Eq, Debug)

///|
pub fn ContractGate::new(
  name : String,
  block_breaking : Bool,
  block_validation_errors : Bool,
  warn_on_risky : Bool,
) -> ContractGate {
  { name, block_breaking, block_validation_errors, warn_on_risky }
}

///|
pub(all) struct GateDecision {
  gate : String
  allowed : Bool
  level : IssueLevel
  reason : String
} derive(Eq, Debug)

///|
pub fn GateDecision::new(
  gate : String,
  allowed : Bool,
  level : IssueLevel,
  reason : String,
) -> GateDecision {
  { gate, allowed, level, reason }
}

///|
pub fn evaluate_contract_gate(
  gate : ContractGate,
  compatibility : CompatibilityReport,
  validation : ValidationReport,
) -> GateDecision {
  if gate.block_breaking && !compatibility.compatible() {
    GateDecision::new(gate.name, false, Error, "breaking_contract_change")
  } else if gate.block_validation_errors && !validation.valid() {
    GateDecision::new(gate.name, false, Error, "payload_validation_failed")
  } else if gate.warn_on_risky && compatibility.has_risk() {
    GateDecision::new(gate.name, true, Warning, "risky_contract_change")
  } else {
    GateDecision::new(gate.name, true, Info, "contract_gate_passed")
  }
}

///|
pub fn strict_contract_gate() -> ContractGate {
  ContractGate::new("strict-contract-gate", true, true, true)
}
