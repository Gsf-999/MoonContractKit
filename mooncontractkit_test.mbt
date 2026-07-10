///|
test "contract replaces duplicate fields" {
  let contract = DataContract::new("event", "1.0.0", false)
  contract.add_field(ContractField::new("id", Text, true, false, "id"))
  contract.add_field(ContractField::new("id", Integer, true, false, "id"))
  assert_eq(contract.fields.length(), 1)
  assert_eq(contract.fields[0].typ.name(), "integer")
}

///|
test "additive optional field is compatible" {
  let report = compare_contracts(user_created_v1(), user_created_v2_additive())
  assert_true(report.compatible())
  assert_eq(report.additive, 1)
  assert_eq(report.breaking, 0)
}

///|
test "required field removal is breaking" {
  let old_contract = user_created_v1()
  let new_contract = DataContract::new("user.created", "2.0.0", false)
  new_contract.add_field(
    ContractField::new("email", Text, false, true, "optional email"),
  )
  let report = compare_contracts(old_contract, new_contract)
  assert_false(report.compatible())
  assert_true(report.to_json().contains("required_field_removed"))
}

///|
test "type changes and required additions are breaking" {
  let report = compare_contracts(user_created_v1(), user_created_v2_breaking())
  assert_false(report.compatible())
  assert_true(report.breaking >= 2)
}

///|
test "pii classification changes are risky" {
  let old_contract = DataContract::new("profile", "1.0.0", true)
  old_contract.add_field(ContractField::new("nickname", Text, false, false, ""))
  let new_contract = DataContract::new("profile", "1.1.0", true)
  new_contract.add_field(ContractField::new("nickname", Text, false, true, ""))
  let report = compare_contracts(old_contract, new_contract)
  assert_true(report.compatible())
  assert_true(report.has_risk())
}

///|
test "payload validation detects missing required field" {
  let report = validate_payload(user_created_v1(), [
    ObservedField::new("email", Text, true),
  ])
  assert_false(report.valid())
  assert_true(report.to_json().contains("required_field_missing"))
}

///|
test "payload validation detects type mismatch" {
  let report = validate_payload(user_created_v1(), [
    ObservedField::new("user_id", Integer, true),
    ObservedField::new("created_at", Timestamp, true),
  ])
  assert_false(report.valid())
  assert_true(report.to_json().contains("field_type_mismatch"))
}

///|
test "payload validation warns on unexpected field" {
  let report = validate_payload(user_created_v1(), [
    ObservedField::new("user_id", Text, true),
    ObservedField::new("created_at", Timestamp, true),
    ObservedField::new("debug", Text, true),
  ])
  assert_true(report.valid())
  assert_eq(report.warnings, 1)
}

///|
test "strict gate blocks breaking contract changes" {
  let gate = evaluate_contract_gate(
    strict_contract_gate(),
    compare_contracts(user_created_v1(), user_created_v2_breaking()),
    validate_payload(user_created_v1(), []),
  )
  assert_false(gate.allowed)
  assert_eq(gate.reason, "breaking_contract_change")
}

///|
test "strict gate warns on risky compatible changes" {
  let old_contract = DataContract::new("profile", "1.0.0", true)
  old_contract.add_field(ContractField::new("nickname", Text, false, false, ""))
  let new_contract = DataContract::new("profile", "1.1.0", true)
  new_contract.add_field(ContractField::new("nickname", Text, false, true, ""))
  let gate = evaluate_contract_gate(
    strict_contract_gate(),
    compare_contracts(old_contract, new_contract),
    validate_payload(new_contract, []),
  )
  assert_true(gate.allowed)
  assert_eq(gate.level.name(), "warning")
}

///|
test "gate passes additive valid payload" {
  let contract = user_created_v2_additive()
  let gate = evaluate_contract_gate(
    strict_contract_gate(),
    compare_contracts(user_created_v1(), contract),
    validate_payload(contract, [
      ObservedField::new("user_id", Text, true),
      ObservedField::new("created_at", Timestamp, true),
    ]),
  )
  assert_true(gate.allowed)
  assert_eq(gate.reason, "contract_gate_passed")
}
