///|
fn escape_json(value : String) -> String {
  let buf = StringBuilder()
  for i = 0; i < value.length(); i = i + 1 {
    match value.get_char(i) {
      Some('\\') => buf.write_string("\\\\")
      Some('"') => buf.write_string("\\\"")
      Some('\n') => buf.write_string("\\n")
      Some('\r') => buf.write_string("\\r")
      Some('\t') => buf.write_string("\\t")
      Some(ch) => buf.write_char(ch)
      None => ()
    }
  }
  buf.to_string()
}

///|
pub fn ContractIssue::to_json(self : ContractIssue) -> String {
  "{\"code\":\"\{escape_json(self.code)}\",\"level\":\"\{self.level.name()}\",\"kind\":\"\{self.kind.name()}\",\"field\":\"\{escape_json(self.field)}\",\"message\":\"\{escape_json(self.message)}\"}"
}

///|
pub fn CompatibilityReport::to_json(self : CompatibilityReport) -> String {
  let buf = StringBuilder()
  buf.write_string(
    "{\"old\":\"\{escape_json(self.old_name)}\",\"new\":\"\{escape_json(self.new_name)}\",\"compatible\":\{self.compatible()},\"breaking\":\{self.breaking},\"risky\":\{self.risky},\"additive\":\{self.additive},\"issues\":[",
  )
  for i = 0; i < self.issues.length(); i = i + 1 {
    if i > 0 {
      buf.write_string(",")
    }
    buf.write_string(self.issues[i].to_json())
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn ValidationIssue::to_json(self : ValidationIssue) -> String {
  "{\"code\":\"\{escape_json(self.code)}\",\"level\":\"\{self.level.name()}\",\"field\":\"\{escape_json(self.field)}\",\"message\":\"\{escape_json(self.message)}\"}"
}

///|
pub fn ValidationReport::to_json(self : ValidationReport) -> String {
  let buf = StringBuilder()
  buf.write_string(
    "{\"contract\":\"\{escape_json(self.contract_name)}\",\"valid\":\{self.valid()},\"errors\":\{self.errors},\"warnings\":\{self.warnings},\"issues\":[",
  )
  for i = 0; i < self.issues.length(); i = i + 1 {
    if i > 0 {
      buf.write_string(",")
    }
    buf.write_string(self.issues[i].to_json())
  }
  buf.write_string("]}")
  buf.to_string()
}

///|
pub fn GateDecision::to_json(self : GateDecision) -> String {
  "{\"gate\":\"\{escape_json(self.gate)}\",\"allowed\":\{self.allowed},\"level\":\"\{self.level.name()}\",\"reason\":\"\{escape_json(self.reason)}\"}"
}
