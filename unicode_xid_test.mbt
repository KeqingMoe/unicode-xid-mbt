test "version" {
  let _ = @unicode_xid.version
}

test "start" {
  for ch in "Az啊" {
    assert_eq(@unicode_xid.is_xid_start(ch), true)
  }
  for ch in "0_+ (" {
    assert_eq(@unicode_xid.is_xid_start(ch), false)
  }
}

test "continue" {
  for ch in "Az啊_0" {
    assert_eq(@unicode_xid.is_xid_continue(ch), true)
  }
  for ch in "+ (" {
    assert_eq(@unicode_xid.is_xid_continue(ch), false)
  }
}
