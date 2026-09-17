# Brewfile para macOS (Apple Silicon ARM64)
# Instalar con: brew bundle --file=~/.dotfiles/Brewfile

# Taps oficiales y recomendados
tap "homebrew/bundle"
tap "homebrew/services"

# Core Shell & CLI Moderno
brew "git"
brew "zsh"
brew "stow"                  # Gestor de symlinks de dotfiles
brew "starship"              # Prompt multiplataforma ultra-rápido
brew "fastfetch"             # Información del sistema CLI
brew "btop"                  # Monitor de recursos interactivo
brew "fzf"                   # Buscador difuso (Fuzzy Finder)
brew "ripgrep"               # Reemplazo ultra-rápido de grep
brew "fd"                    # Reemplazo ergonómico de find
brew "bat"                   # Reemplazo de cat con resaltado de sintaxis
brew "eza"                   # Reemplazo moderno de ls con íconos y soporte git
brew "zoxide"                # Navegación inteligente de directorios (cd con memoria)

# Plugins de Zsh empaquetados por Homebrew (carga nativa sin overhead)
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh-completions"

# Editores y Multiplexores
brew "neovim"
brew "tmux"

# Runtimes & Entornos de Desarrollo
brew "fnm"                   # Fast Node Manager (nativo en Rust, alternativa rápida a NVM)
brew "uv"                    # Gestor de paquetes y versiones de Python ultra-rápido

# Fuentes Nerd Font (requeridas para íconos en Ghostty, Starship y Eza)
cask "font-jetbrains-mono-nerd-font"

# Aplicaciones GUI / Casks
cask "ghostty"               # Emulador de terminal acelerado por GPU (Metal en macOS)
cask "visual-studio-code"    # Editor gráfico
cask "raycast"               # Lanzador y gestor de productividad (reemplazo superior de Spotlight)
