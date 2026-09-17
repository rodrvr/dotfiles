# ~/.zshrc - Configuración interactiva para Zsh en macOS (Apple Silicon)

# ==============================================================================
# 1. Rutas y Prefix de Homebrew
# ==============================================================================
if (( ! ${+HOMEBREW_PREFIX} )); then
    if [[ -d "/opt/homebrew" ]]; then
        HOMEBREW_PREFIX="/opt/homebrew"
    elif [[ -d "/usr/local" ]]; then
        HOMEBREW_PREFIX="/usr/local"
    fi
fi

# ==============================================================================
# 2. Configuración de Historial
# ==============================================================================
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "$(dirname "$HISTFILE")" 2>/dev/null
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # Guarda timestamps en el historial
setopt SHARE_HISTORY             # Comparte historial entre diferentes sesiones abiertas
setopt HIST_IGNORE_DUPS          # No guarda comandos repetidos consecutivos
setopt HIST_IGNORE_ALL_DUPS      # Elimina entradas antiguas duplicadas
setopt HIST_IGNORE_SPACE         # Comandos que comienzan con espacio no se guardan
setopt HIST_REDUCE_BLANKS        # Elimina espacios innecesarios
setopt HIST_VERIFY               # Muestra el comando antes de ejecutarlo si usa historial

# ==============================================================================
# 3. Sistema de Completado (compinit con caché)
# ==============================================================================
# Cargar zsh-completions de Homebrew en fpath antes de inicializar compinit
if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
# Solo regenerar compdump una vez al día para no ralentizar el inicio del shell
ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-$ZSH_VERSION"
mkdir -p "$(dirname "$ZCOMPDUMP")" 2>/dev/null

if [[ -s "$ZCOMPDUMP" && $(find "$ZCOMPDUMP" -mtime -1 2>/dev/null) ]]; then
    compinit -C -d "$ZCOMPDUMP"
else
    compinit -d "$ZCOMPDUMP"
fi

# Estilos de completado (navegación visual interactiva con flechas)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# ==============================================================================
# 4. Integración de Herramientas Core (FZF, Zoxide, FNM)
# ==============================================================================
# FZF: Atajos (Ctrl+R para historial, Ctrl+T para archivos, Alt+C para carpetas)
if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
    
    # Paleta y opciones por defecto de FZF (Nord Theme)
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info \
        --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1 \
        --color=fg+:#eceff4,bg+:#3b4252,hl+:#88c0d0 \
        --color=info:#ebcb8b,prompt:#bf616a,pointer:#b48ead \
        --color=marker:#a3be8c,spinner:#b48ead,header:#5e81ac"

    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
    fi
fi

# Zoxide (reemplazo inteligente de cd)
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# FNM (Fast Node Manager) si está instalado
if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd)"
fi

# ==============================================================================
# 5. Carga de Plugins Nativos de Zsh (Instalados con Homebrew)
# ==============================================================================
# Autosuggestions (sugiere comandos pasados en tiempo real)
if [[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#616e88"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Syntax Highlighting (debe cargarse al final de los plugins de Zsh)
if [[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ==============================================================================
# 6. Atajos de Teclado (Keybindings)
# ==============================================================================
bindkey -e                                 # Modo Emacs estándar
bindkey '^ ' autosuggest-accept            # Ctrl + Espacio: aceptar autosugerencia
bindkey '^@' autosuggest-accept            # Respaldo Ctrl + Espacio (código ASCII NUL)
bindkey '^f' autosuggest-accept            # Ctrl + F: aceptar autosugerencia completa
bindkey '^e' autosuggest-accept            # Ctrl + E: aceptar autosugerencia completa

# Navegación palabra por palabra con Option/Alt + Flechas (habilitado en Ghostty)
bindkey '^[b' backward-word                # Option + Flecha Izquierda (o Alt+b)
bindkey '^[f' forward-word                 # Option + Flecha Derecha (o Alt+f)
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# ==============================================================================
# 7. Aliases Modernos y Específicos para macOS
# ==============================================================================
# Navegación y listado de archivos con Eza
if command -v eza &>/dev/null; then
    alias ls='eza --icons'
    alias ll='eza -lah --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --icons --level=2'
else
    alias ls='ls -G'
    alias ll='ls -la'
fi

# Visualización con Bat
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    export BAT_THEME="Nord"
fi

# Gestor de paquetes macOS (equivalente a 'sudo dnf upgrade --refresh')
alias update='brew update && brew upgrade && brew cleanup'
alias services='brew services'

# Portapapeles e integración de sistema macOS
alias copy='pbcopy'
alias paste='pbpaste'
alias o='open .'

# Utilidades de desarrollo
alias v='nvim'
alias ff='fastfetch'
alias bt='btop'
alias claude='claude --dangerously-skip-permissions'

# ==============================================================================
# 8. Prompt Starship & Inicio
# ==============================================================================
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# Mostrar información del sistema con Fastfetch al abrir la terminal
if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
