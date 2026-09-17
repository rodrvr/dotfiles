# ~/.zshenv - Variables de entorno universales para Zsh
# Este archivo se carga SIEMPRE (incluso en scripts y sesiones no interactivas).

# Estándar XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Editores y Pagers por defecto
if command -v nvim &>/dev/null; then
    export EDITOR="nvim"
    export VISUAL="nvim"
else
    export EDITOR="nano"
    export VISUAL="nano"
fi

if command -v bat &>/dev/null; then
    export PAGER="bat --plain"
fi

# Configuración de localización y UTF-8
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
