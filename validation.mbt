///|
pub(all) struct ValidationIssue {
  code : String
  level : IssueLevel
  field : String
  message : String
} derive(Eq, Debug)

///|
pub fn ValidationIssue::new(
  code : String,
  level : IssueLevel,
  field : String,
  message : String,
) -> ValidationIssue {
  { code, level, field, message }
}

///|
pub(all) struct ValidationReport {
  contract_name : String
  issues : Array[ValidationIssue]
  errors : Int
  warnings : Int
} derive(Eq, Debug)

///|
pub fn ValidationReport::new(
  contract_name : String,
  issues : Array[ValidationIssue],
) -> ValidationReport {
  let mut errors = 0
  let mut warnings = 0
  for issue in issues {
    match issue.level {
      Error => errors = errors + 1
      Warning => warnings = warnings + 1
      Info => ()
    }
  }
  { contract_name, issues, errors, warnings }
}

///|
pub fn ValidationReport::valid(self : ValidationReport) -> Bool {
  self.errors == 0
}

///|
pub fn validate_payload(
  contract : DataContract,
  payload : Array[ObservedField],
) -> ValidationReport {
  let issues : Array[ValidationIssue] = []
  for field in contract.fields {
    let index = observed_index(payload, field.name)
    if index < 0 {
      if field.required {
        issues.push(
          ValidationIssue::new(
            "required_field_missing",
            Error,
            field.name,
            "required field is missing from observed payload",
          ),
        )
      }
    } else if payload[index].typ != field.typ {
      issues.push(
        ValidationIssue::new(
          "field_type_mismatch",
          Error,
          field.name,
          "observed payload type does not match contract field type",
        ),
      )
    }
  }
  if !contract.allow_extra_fields {
    for item in payload {
      if item.present && !contract.has_field(item.name) {
        issues.push(
          ValidationIssue::new(
            "unexpected_field",
            Warning,
            item.name,
            "payload contains a field outside the contract",
          ),
        )
      }
    }
  }
  ValidationReport::new(contract.name, issues)
}

///|
fn observed_index(payload : Array[ObservedField], name : String) -> Int {
  for i = 0; i < payload.length(); i = i + 1 {
    if payload[i].present && payload[i].name == name {
      return i
    }
  }
  -1
}
