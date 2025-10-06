# unicode_xid

获取一个字符是否属于 `XID_Start` 或 `XID_Continue`，可以用于判定标识符。

## 安装

```shell
moon add KeqingMoe/unicode_xid
```

### 更新

在源码所在文件夹中执行以下命令以拉取最新的 Unicode 字符数据库：

```shell
cd fetch
moon run .
```

## 例子

```moonbit
test {
  let v = @unicode_xid.version
  println("Unicode Version: \{v.0}.\{v.1}.\{v.2}")
  for ch in "Az_+" {
    println("is `\{ch}` start? \{@unicode_xid.is_xid_start(ch)}")
    println("is `\{ch}` continue? \{@unicode_xid.is_xid_continue(ch)}")
  }
}
```

## 参考

- [unicode-rs](https://github.com/unicode-rs/unicode-xid)
