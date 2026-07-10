///|
pub fn user_created_v1() -> DataContract {
  let contract = DataContract::new("user.created", "1.0.0", false)
  contract.add_field(
    ContractField::new("user_id", Text, true, false, "stable user id"),
  )
  contract.add_field(
    ContractField::new("email", Text, false, true, "optional email address"),
  )
  contract.add_field(
    ContractField::new("created_at", Timestamp, true, false, "event time"),
  )
  contract
}

///|
pub fn user_created_v2_additive() -> DataContract {
  let contract = DataContract::new("user.created", "1.1.0", false)
  contract.add_field(
    ContractField::new("user_id", Text, true, false, "stable user id"),
  )
  contract.add_field(
    ContractField::new("email", Text, false, true, "optional email address"),
  )
  contract.add_field(
    ContractField::new("created_at", Timestamp, true, false, "event time"),
  )
  contract.add_field(
    ContractField::new("locale", Text, false, false, "optional locale"),
  )
  contract
}

///|
pub fn user_created_v2_breaking() -> DataContract {
  let contract = DataContract::new("user.created", "2.0.0", false)
  contract.add_field(
    ContractField::new("user_id", Integer, true, false, "numeric user id"),
  )
  contract.add_field(
    ContractField::new("email", Text, true, true, "required email address"),
  )
  contract
}
