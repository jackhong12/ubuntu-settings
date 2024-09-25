# Zsh

## Useful Scripts
### Only included script once
```zsh
if [[ -v __INCLUDE_VAR__ ]]; then
  return 0;
else
  __INCLUDE_VAR__=1
fi
```
