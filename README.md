# bd

Bash Framework to Build CLI tools

**This project is in progress. Please see [TODO](#todo) and PRs are welcome.**

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

# TODO

- `config` command: Stress-free configuration management
- `bd eject`: Make your script independent from `bd`
- and more!
