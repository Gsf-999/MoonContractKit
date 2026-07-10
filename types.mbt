///|
pub(all) enum FieldType {
  Text
  Integer
  Decimal
  Boolean
  Timestamp
  Object
  Array
  Unknown
} derive(Eq, Debug)

///|
pub fn FieldType::name(self : FieldType) -> String {
  match self {
    Text => "text"
    Integer => "integer"
    Decimal => "decimal"
    Boolean => "boolean"
    Timestamp => "timestamp"
    Object => "object"
    Array => "array"
    Unknown => "unknown"
  }
}

///|
pub(all) enum IssueLevel {
  Info
  Warning
  Error
} derive(Eq, Debug)

///|
pub fn IssueLevel::name(self : IssueLevel) -> String {
  match self {
    Info => "info"
    Warning => "warning"
    Error => "error"
  }
}

///|
pub(all) enum ChangeKind {
  Additive
  Risky
  Breaking
} derive(Eq, Debug)

///|
pub fn ChangeKind::name(self : ChangeKind) -> String {
  match self {
    Additive => "additive"
    Risky => "risky"
    Breaking => "breaking"
  }
}

///|
pub(all) struct ContractField {
  name : String
  typ : FieldType
  required : Bool
  pii : Bool
  description : String
} derive(Eq, Debug)

///|
pub fn ContractField::new(
  name : String,
  typ : FieldType,
  required : Bool,
  pii : Bool,
  description : String,
) -> ContractField {
  { name, typ, required, pii, description }
}

///|
pub(all) struct DataContract {
  name : String
  version : String
  fields : Array[ContractField]
  allow_extra_fields : Bool
} derive(Eq, Debug)

///|
pub fn DataContract::new(
  name : String,
  version : String,
  allow_extra_fields : Bool,
) -> DataContract {
  { name, version, fields: [], allow_extra_fields }
}

///|
pub fn DataContract::add_field(
  self : DataContract,
  field : ContractField,
) -> Unit {
  for i = 0; i < self.fields.length(); i = i + 1 {
    if self.fields[i].name == field.name {
      self.fields[i] = field
      return
    }
  }
  self.fields.push(field)
}

///|
pub fn DataContract::has_field(self : DataContract, name : String) -> Bool {
  for field in self.fields {
    if field.name == name {
      return true
    }
  }
  false
}

///|
pub fn DataContract::field_index(self : DataContract, name : String) -> Int {
  for i = 0; i < self.fields.length(); i = i + 1 {
    if self.fields[i].name == name {
      return i
    }
  }
  -1
}

///|
pub(all) struct ObservedField {
  name : String
  typ : FieldType
  present : Bool
} derive(Eq, Debug)

///|
pub fn ObservedField::new(
  name : String,
  typ : FieldType,
  present : Bool,
) -> ObservedField {
  { name, typ, present }
}
