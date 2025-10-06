fn in_range(rngs: ArrayView[(Char, Char)], ch: Char) -> Bool {
  let lower_bound = loop rngs {
    [] => return false
    [rng] if rng.0 <= ch => rng
    [..] as rngs => {
      let mid = rngs.length() / 2
      continue if rngs[mid].0 <= ch {
        rngs[mid:]
      } else {
        rngs[:mid]
      }
    }
  }
  ch <= lower_bound.1
}

/// 当 `ch` 为 `XID_Start` 时返回 `true`
pub fn is_xid_start(ch: Char) -> Bool {
  in_range(xid_starts, ch)
}

/// 当 `ch` 为 `XID_Continue` 时返回 `true`
pub fn is_xid_continue(ch: Char) -> Bool {
  in_range(xid_continues, ch)
}
