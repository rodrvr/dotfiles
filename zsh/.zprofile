# ~/.zprofile - Entorno de Login Shell para macOS
# Se ejecuta una sola vez al iniciar sesión en el emulador de terminal.

# 1. Integración de Homebrew (Apple Silicon ARM64 / fallback Intel)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. Rutas de ejecución de usuario (sin duplicados gracias a typeset -U)
typeset -U path PATH
path=(
    "$HOME/.local/bin"
    "$HOME/bin"
    ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/bin"}
    ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/sbin"}
    "$HOME/.cargo/bin"
    $path
)
export PATH
