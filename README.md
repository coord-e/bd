# bd

Bash Framework to Build CLI tools

**This project is in progress. Please see [TODO](#TODO) and PRs are welcome.**

# Example

```bash
#!/usr/bin/env bd

name "hello"

info "Started!"

for i in `seq 10`; do
  progress "I'm makin' a progress"
  sleep 1
done

confirm "Are you ok?" || error "You're not OK...";

info "Exiting..."
```

```
[WARN]  Profiling on the first run...
[WARN]  Done profiling and cached the result.
[INFO]  Started!
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

- `arg` command: Easy argument parsing and help generation
- explicit `progress` range: Provide a way to set `progress` range without profiling
- `config` command: Stress-free configuration management
- `bd eject`: Make your script independent from `bd`
- and more!
