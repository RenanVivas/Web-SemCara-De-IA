#!/usr/bin/env bash
# Instala as skills e o agente desta biblioteca no Claude Code.
# Uso:
#   ./install.sh            # copia para ~/.claude (global)
#   ./install.sh --link     # cria symlinks (git pull atualiza na hora)
#   ./install.sh --project  # instala em ./.claude do diretório atual
set -euo pipefail

ORIGEM="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DESTINO="${HOME}/.claude"
MODO="copy"

for arg in "$@"; do
  case "$arg" in
    --link) MODO="link" ;;
    --project) DESTINO="$(pwd)/.claude" ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "Opção desconhecida: $arg" >&2; exit 1 ;;
  esac
done

mkdir -p "$DESTINO/skills" "$DESTINO/agents"
# Backups ficam fora de skills/ e agents/ para o Claude não carregar versões duplicadas.
BACKUP_DIR="$DESTINO/backups/web-sem-cara-de-ia-$(date +%Y%m%d%H%M%S)"

instalar() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local tipo; tipo="$(basename "$(dirname "$dst")")"
    local backup="$BACKUP_DIR/$tipo/$(basename "$dst")"
    mkdir -p "$(dirname "$backup")"
    mv "$dst" "$backup"
    echo "  backup: $backup"
  fi
  if [ "$MODO" = "link" ]; then ln -s "$src" "$dst"; else cp -R "$src" "$dst"; fi
  echo "  ok: $dst"
}

echo "Skills → $DESTINO/skills ($MODO)"
for skill in "$ORIGEM"/skills/*/; do
  nome="$(basename "$skill")"
  instalar "${skill%/}" "$DESTINO/skills/$nome"
done

echo "Agentes → $DESTINO/agents ($MODO)"
for agente in "$ORIGEM"/agents/*.md; do
  instalar "$agente" "$DESTINO/agents/$(basename "$agente")"
done

echo "Pronto. Reinicie o Claude Code para carregar as skills."
