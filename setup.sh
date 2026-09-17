#!/usr/bin/env bash
# ==============================================================================
# setup.sh - Script de Inicialización Idempotente para macOS (Apple Silicon ARM)
# ==============================================================================
set -euo pipefail

# Colores para salida informativa
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

info()    { printf "${BLUE}[INFO]${RESET} %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET} %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET} %s\n" "$*"; }
error()   { printf "${RED}[ERROR]${RESET} %s\n" "$*"; exit 1; }

# Determinar directorio raíz de los dotfiles
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
info "Iniciando aprovisionamiento desde: $DOTFILES_DIR"

# 1. Verificación del Sistema Operativo
if [[ "$(uname -s)" != "Darwin" ]]; then
    warn "Este script está optimizado para macOS (Darwin). Sistema detectado: $(uname -s)"
    read -p "¿Deseas continuar de todas formas? [s/N]: " -r response
    if [[ ! "$response" =~ ^([sS][iI]?|[yY][eE][sS]?)$ ]]; then
        info "Operación cancelada."
        exit 0
    fi
fi

# 2. Xcode Command Line Tools
info "Verificando Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    info "Instalando Xcode Command Line Tools..."
    xcode-select --install
    echo "Presiona Enter una vez que la instalación de Xcode CLI Tools haya finalizado en la ventana gráfica..."
    read -r
    success "Xcode Command Line Tools instaladas."
else
    success "Xcode Command Line Tools ya están presentes."
fi

# 3. Instalación e Inicialización de Homebrew
info "Verificando Homebrew..."
BREW_BIN="/opt/homebrew/bin/brew"

if ! command -v brew &>/dev/null && [[ ! -f "$BREW_BIN" ]]; then
    info "Homebrew no detectado. Descargando e instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Configurar entorno de Homebrew en la sesión actual
if [[ -f "$BREW_BIN" ]]; then
    eval "$("$BREW_BIN" shellenv)"
elif command -v brew &>/dev/null; then
    eval "$(brew shellenv)"
else
    error "No se pudo localizar el binario de Homebrew tras la instalación."
fi
success "Homebrew activo: $(brew --version | head -n 1)"

# 4. Instalación de paquetes declarados en Brewfile
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    info "Ejecutando 'brew bundle'..."
    brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock || true
    success "Dependencias de Brewfile instaladas con éxito."
else
    warn "No se encontró el archivo Brewfile en $DOTFILES_DIR"
fi

# 5. Creación de directorios base del sistema XDG
info "Garantizando estructura de directorios XDG..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/state/zsh"
mkdir -p "$HOME/.cache"
success "Directorios base creados."

# 6. Enlace de Dotfiles (GNU Stow con respaldo automático)
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        warn "Archivo existente detectado en $target. Moviendo a $backup"
        mv "$target" "$backup"
    fi
}

# Realizar backup de archivos conflictivos generados por defecto en macOS
backup_if_exists "$HOME/.zshrc"
backup_if_exists "$HOME/.zprofile"
backup_if_exists "$HOME/.zshenv"

MODULES=("zsh" "starship" "ghostty" "fastfetch" "git")

if command -v stow &>/dev/null; then
    info "Aplicando symlinks con GNU Stow..."
    cd "$DOTFILES_DIR"
    for module in "${MODULES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$module" ]]; then
            info "Stowing módulo: $module"
            stow -v -R -t "$HOME" "$module"
        fi
    done
    success "Módulos enlazados con GNU Stow."
else
    warn "GNU Stow no encontrado. Aplicando enlaces simbólicos manuales..."
    # Fallback sin Stow
    ln -sf "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
    ln -sf "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    
    mkdir -p "$HOME/.config/starship" "$HOME/.config/ghostty" "$HOME/.config/fastfetch" "$HOME/.config/git"
    ln -sf "$DOTFILES_DIR/starship/.config/starship.toml" "$HOME/.config/starship.toml"
    ln -sf "$DOTFILES_DIR/ghostty/.config/ghostty/config" "$HOME/.config/ghostty/config"
    ln -sf "$DOTFILES_DIR/fastfetch/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
    ln -sf "$DOTFILES_DIR/git/.config/git/config" "$HOME/.config/git/config"
    ln -sf "$DOTFILES_DIR/git/.config/git/ignore" "$HOME/.config/git/ignore"
    success "Enlaces simbólicos aplicados manualmente."
fi

# 7. Verificación de Shell por defecto
info "Verificando Shell por defecto..."
CURRENT_SHELL="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}' || echo "$SHELL")"
TARGET_SHELL="$(command -v zsh)"

if [[ "$CURRENT_SHELL" != "$TARGET_SHELL" ]]; then
    info "Cambiando shell por defecto a $TARGET_SHELL..."
    # Añadir a /etc/shells si no existe
    if ! grep -q "^$TARGET_SHELL$" /etc/shells 2>/dev/null; then
        echo "$TARGET_SHELL" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s "$TARGET_SHELL" || warn "No se pudo cambiar el shell automáticamente. Ejecuta: chsh -s $TARGET_SHELL"
else
    success "Zsh ya es tu shell por defecto ($CURRENT_SHELL)."
fi

# 8. Resumen y Finalización
printf "\n"
success "================================================================="
success " ¡Entorno macOS aprovisionado con éxito!                          "
success "================================================================="
info "Pasos finales:"
info "1. Abre la aplicación Ghostty desde Spotlight/Raycast o Aplicaciones."
info "2. Disfruta de tu nuevo entorno Zsh + Starship + Fastfetch."
info "================================================================="
