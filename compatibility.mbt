///|
pub(all) struct ContractIssue {
  code : String
  level : IssueLevel
  kind : ChangeKind
  field : String
  message : String
} derive(Eq, Debug)

///|
pub fn ContractIssue::new(
  code : String,
  level : IssueLevel,
  kind : ChangeKind,
  field : String,
  message : String,
) -> ContractIssue {
  { code, level, kind, field, message }
}

///|
pub(all) struct CompatibilityReport {
  old_name : String
  new_name : String
  issues : Array[ContractIssue]
  breaking : Int
  risky : Int
  additive : Int
} derive(Eq, Debug)

///|
pub fn CompatibilityReport::new(
  old_name : String,
  new_name : String,
  issues : Array[ContractIssue],
) -> CompatibilityReport {
  let mut breaking = 0
  let mut risky = 0
  let mut additive = 0
  for issue in issues {
    match issue.kind {
      Breaking => breaking = breaking + 1
      Risky => risky = risky + 1
      Additive => additive = additive + 1
    }
  }
  { old_name, new_name, issues, breaking, risky, additive }
}

///|
pub fn CompatibilityReport::compatible(self : CompatibilityReport) -> Bool {
  self.breaking == 0
}

///|
pub fn CompatibilityReport::has_risk(self : CompatibilityReport) -> Bool {
  self.risky > 0
}

///|
pub fn compare_contracts(
  old_contract : DataContract,
  new_contract : DataContract,
) -> CompatibilityReport {
  let issues : Array[ContractIssue] = []
  for old_field in old_contract.fields {
    let index = new_contract.field_index(old_field.name)
    if index < 0 {
      if old_field.required {
        issues.push(
          ContractIssue::new(
            "required_field_removed",
            Error,
            Breaking,
            old_field.name,
            "required field was removed from the new contract",
          ),
        )
      } else {
        issues.push(
          ContractIssue::new(
            "optional_field_removed",
            Warning,
            Risky,
            old_field.name,
            "optional field was removed and may affect consumers",
          ),
        )
      }
    } else {
      let next = new_contract.fields[index]
      if old_field.typ != next.typ {
        issues.push(
          ContractIssue::new(
            "field_type_changed",
            Error,
            Breaking,
            old_field.name,
            "field type changed and may break existing consumers",
          ),
        )
      }
      if !old_field.required && next.required {
        issues.push(
          ContractIssue::new(
            "field_became_required",
            Error,
            Breaking,
            old_field.name,
            "optional field became required",
          ),
        )
      }
      if !old_field.pii && next.pii {
        issues.push(
          ContractIssue::new(
            "pii_classification_added",
            Warning,
            Risky,
            old_field.name,
            "field is now marked as personal data and needs review",
          ),
        )
      }
    }
  }
  for new_field in new_contract.fields {
    if !old_contract.has_field(new_field.name) {
      if new_field.required {
        issues.push(
          ContractIssue::new(
            "required_field_added",
            Error,
            Breaking,
            new_field.name,
            "new required field breaks older producers",
          ),
        )
      } else {
        issues.push(
          ContractIssue::new(
            "optional_field_added",
            Info,
            Additive,
            new_field.name,
            "new optional field is additive",
          ),
        )
      }
    }
  }
  CompatibilityReport::new(old_contract.name, new_contract.name, issues)
}
