async fn fetch_verion() -> String? {
  let (response, body) = @http.get("https://www.unicode.org/Public/UNIDATA/ReadMe.txt")
  guard response.code == 200
  let ver_re = @regexp.compile("Version (\\d+)\\.(\\d+)\\.(\\d+)")
  guard ver_re.match_(body.text()) is Some(matches)
  match matches.results() {
    [_, Some(major), Some(minor), Some(patch)] => Some("(\{major}, \{minor}, \{patch})")
    _ => None
  }
}

async fn get_properties(ucd: Iter[StringView], prop: StringView) -> Array[String] {
  let re = @regexp.compile("^([0-9A-F]+)(?:\\.\\.([0-9A-F]+))? *; *\{prop}")
  let result = Array::new()
  fn push(start: StringView, end: StringView) {
    result.push("('\\u{\{start}}', '\\u{\{end}}')")
  }
  for line in ucd {
    match re.match_(line) {
      Some(m) => match m.results() {
        [_, Some(start), Some(end)] => push(start, end)
        [_, Some(char), None] => push(char, char)
        _ => ()
      }
      _ => ()
    }
  }
  result
}

async fn main {
  println("fetch version")
  guard fetch_verion() is Some(version) else {
    abort("failed to fetch version")
  }

  let ucd = {
    println("fetch UCD")
    let url = "https://www.unicode.org/Public/UNIDATA/DerivedCoreProperties.txt"
    let (response, body) = @http.get(url)
    guard response.code == 200 else {
      abort("fail to fetch UCD")
    }
    body.text().split("\n")
  }

  println("process XID_Start")
  let xid_starts = get_properties(ucd, "XID_Start")

  println("process XID_Continue")
  let xid_continues = get_properties(ucd, "XID_Continue")

  let buf = @buffer.new()
  buf.write_string_utf8("pub let version = \{version}\n\n")
  buf.write_string_utf8("pub typealias Array[(Char, Char)] as Table\n\n")
  fn emit_one(name: StringView, rngs: ArrayView[String]) {
    buf.write_string_utf8("pub let \{name} : Table = [\n")
    for rng in rngs {
      buf.write_string_utf8("  \{rng},\n")
    }
    buf.write_string_utf8("]\n\n")
  }
  emit_one("xid_starts", xid_starts)
  emit_one("xid_continues", xid_continues)
  @fs.write_bytes_to_file("../ucd.mbt", buf.to_bytes())
}
