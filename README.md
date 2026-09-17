# 🍏 macOS Apple Silicon Dotfiles

Dotfiles limpios, modulares e idempotentes optimizados para **macOS (Apple Silicon ARM64)**, **Ghostty**, **Zsh** con plugins nativos y **Starship**.

---

## 🚀 Instalación en una MacBook Nueva

En una terminal de macOS recién instalada, ejecuta:

```bash
# 1. Clonar este repositorio en tu Home
git clone <tu-repositorio-url> ~/.dotfiles

# 2. Ejecutar el script de setup idempotent
cd ~/.dotfiles
./setup.sh
```

El script se encargará automáticamente de:
1. Instalar **Xcode Command Line Tools** (`xcode-select --install`).
2. Instalar **Homebrew** en `/opt/homebrew` y cargarlo en el entorno.
3. Instalar todos los paquetes CLI, fuentes Nerd Font y aplicaciones Cask declaradas en [Brewfile](file:///home/rodrvr/.dotfiles/Brewfile).
4. Respaldar archivos existentes y desplegar los symlinks usando **GNU Stow**.
5. Asegurar directorios de especificación **XDG** (`~/.config`, `~/.local/state/zsh`, etc.).

---

## 📂 Arquitectura Modular

Compatible 100% con `stow <modulo>`:

* **[Brewfile](file:///home/rodrvr/.dotfiles/Brewfile)**: Declaración reproducible de paquetes Homebrew, fuentes (`font-jetbrains-mono-nerd-font`) y casks (`ghostty`, `visual-studio-code`, `raycast`).
* **zsh/**:
  * `.zshenv`: Definición universal de especificación XDG, editores y locale.
  * `.zprofile`: Inicialización de Homebrew para arquitecturas ARM64 y export de PATH libre de duplicados.
  * `.zshrc`: Carga nativa y de alto rendimiento de plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`), integraciones con `fzf`, `zoxide`, `fnm`, aliases modernos (`eza`, `bat`, `brew update`, `pbcopy/pbpaste`) y startup con `fastfetch`.
* **ghostty/**:
  * `.config/ghostty/config`: Emulador acelerado por GPU (Metal) con tema Nord, transparencia (0.85), desenfoque (`background-blur-radius`), soporte de título nativo macOS, `macos-option-as-alt = true` y mapeo de atajos `Cmd` (⌘).
* **starship/**:
  * `.config/starship.toml`: Prompt minimalista con soporte del símbolo del sistema operativo macOS (`󰀵`), Git, stacks de desarrollo y temporizador de ejecución.
* **fastfetch/**:
  * `.config/fastfetch/config.jsonc`: Resumen estético de hardware Apple Silicon (M-series), macOS, memoria, batería, Zsh y Ghostty.
* **git/**:
  * `.config/git/config` y `.config/git/ignore`: Configuración global con reglas contra archivos basura de macOS (`.DS_Store`, `._*`, `.AppleDouble`).

---

## ⌨️ Atajos Clave en Ghostty & Zsh

| Acción | Atajo |
|---|---|
| Aceptar sugerencia Zsh | `Ctrl + Espacio` o `Ctrl + E` / `Ctrl + F` |
| Navegar palabra por palabra | `Option + ←` / `Option + →` |
| Búsqueda difusa en historial | `Ctrl + R` (FZF) |
| Búsqueda difusa de archivos | `Ctrl + T` (FZF) |
| Nueva pestaña en Ghostty | `Cmd + T` |
| Cerrar pestaña/split | `Cmd + W` |
| Split horizontal/vertical | `Cmd + D` / `Cmd + Shift + D` |
| Zoom en split actual | `Cmd + Enter` |
| Cambiar de split | `Cmd + [` / `Cmd + ]` |
