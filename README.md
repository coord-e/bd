# bd

Bash Framework to Build CLI tools

# Example

```bash
#!/usr/bin/env bd

name "hello"
args --you string:World --ok bool

info "Hello, $arg_you"

for i in $(range 1 10); do
  progress "I'm makin' a progress"
  sleep 1
done

if ! $arg_ok; then
  confirm "Are you ok?" || error "You're not OK...";
fi

info "Exiting..."
```

```
[INFO]  Hello, World
  10% ->  I'm makin' a progress
  20% ->  I'm makin' a progress
  30% ->  I'm makin' a progress
  40% ->  I'm makin' a progress
  50% ->  I'm makin' a progress
  60% ->  I'm makin' a progress
  70% ->  I'm makin' a progress
  80% ->  I'm makin' a progress
  90% ->  I'm makin' a progress
 100% ->  I'm makin' a progress
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

- Progress bar support in `progress`
- Output buffering until failure
- User-defined themes
- vim syntax
- Automatically generate completions
- `config` command: Stress-free configuration management
- and more!
