# Zsh Configuration

## Install

```sh
git clone https://github.com/kaar/zsh-config ~/.config/zsh
```

Set `ZDOTDIR` so zsh looks for config in `~/.config/zsh` instead of `$HOME`:

```sh
ln -fs ~/.config/zsh/.zshenv ~/.zshenv
```

This creates a small `~/.zshenv` that points zsh to `~/.config/zsh`,
where the actual `.zshrc` lives.

## Reload

```sh
source $ZDOTDIR/.zshrc
# or
reload
```
