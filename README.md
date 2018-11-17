# bd

Bash Framework to accelerate your daily scripting

日本語: [README.ja.md](README.ja.md)

# Install

```bash
curl -fsSL https://coord-e.github.io/bd/get.sh | bash
```

# Example

See [examples/cli](examples/cli) for full-featured example

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

You can make your `bd` script independent from `bd`, with `bd eject`

```bash
bd eject script.bd script.sh

# Now, script.sh acts the same as script.bd, but it doesn't require `bd` binary
./script.sh
```

# TODO

- short option support in `args`
- Progress bar support in `progress`
- more useful examples
- vim syntax
- Output buffering until failure
- User-defined themes
- Automatically generate completions
- `config` command: Stress-free configuration management
- and more!
