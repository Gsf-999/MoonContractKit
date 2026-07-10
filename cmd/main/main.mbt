///|
fn main {
  let old_contract = @contract.user_created_v1()
  let new_contract = @contract.user_created_v2_additive()
  let compatibility = @contract.compare_contracts(old_contract, new_contract)
  let validation = @contract.validate_payload(new_contract, [
    @contract.ObservedField::new("user_id", @contract.Text, true),
    @contract.ObservedField::new("created_at", @contract.Timestamp, true),
  ])
  let gate = @contract.evaluate_contract_gate(
    @contract.strict_contract_gate(),
    compatibility,
    validation,
  )
  println("MoonContractKit demo")
  println(compatibility.to_json())
  println(validation.to_json())
  println(gate.to_json())
}
