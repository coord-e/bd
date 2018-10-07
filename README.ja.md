# bd

日々のスクリプティングを加速する、Bashフレームワーク

English: [README.md](README.md)

# インストール

## Homebrew

```bash
brew install coord-e/bd/bd
```

## インストールスクリプト

```bash
curl -fsSL https://coord-e.github.io/bd/get.sh | bash
```

# 例

[examples/cli](examples/cli)に詳細な例があります

```bash
#!/usr/bin/env bd

name "hello"
args --you string:World --ok bool

info "Hello, $arg_you"

for i in $(range 1 10); do
  progress "I'm making a progress"
  sleep 1
done

if ! $arg_ok; then
  confirm "Are you ok?" || error "You're not OK...";
fi

info "Exiting..."
```

出力:

```
[INFO]  Hello, World
  10% ->  I'm making a progress
  20% ->  I'm making a progress
  30% ->  I'm making a progress
  40% ->  I'm making a progress
  50% ->  I'm making a progress
  60% ->  I'm making a progress
  70% ->  I'm making a progress
  80% ->  I'm making a progress
  90% ->  I'm making a progress
 100% ->  I'm making a progress
Are you ok? [y/n] > n
[ERROR]  You're not OK...
[INFO]  Exiting...
```

## Eject

`bd eject`によって、`bd`スクリプトを`bd`に依存しない純粋なbashスクリプトに変換することができます

```bash
bd eject script.bd script.sh

# script.shはscript.bdと同じように使えるが、bdがインストールされていない環境でも使用できる
./script.sh
```

# TODO

- Progress bar support in `progress`
- Output buffering until failure
- User-defined themes
- vim syntax
- Automatically generate completions
- `config` command: Stress-free configuration management
- and more!
