# Web Sem Cara de IA — biblioteca de skills de design, motion, 2D, 3D e Godot

Skills e agente para Claude Code (e outros agentes de código) que transformam pedidos
como "faz um post", "anima esse site", "cria uma cena 3D" ou "monta isso no Godot" em
entregas com direção de arte — e sem a cara genérica de "feito por IA".

## O que tem aqui

| Caminho | O que é |
|---|---|
| [`skills/mestre-de-design/`](skills/mestre-de-design/SKILL.md) | **Agente Mestre de Design**: orquestra composição, motion, 2D, 3D, vídeo e Godot; escolhe a ferramenta e verifica a entrega |
| ├─ [`references/composicao-diagramacao.md`](skills/mestre-de-design/references/composicao-diagramacao.md) | Tensão fora do centro, regra dos terços, espaço do olhar, margem, título × parágrafo |
| ├─ [`references/anti-slop.md`](skills/mestre-de-design/references/anti-slop.md) | Impeccable, taste-skill, Emil Kowalski skills e lista de sinais de "AI slop" |
| ├─ [`references/video-programatico.md`](skills/mestre-de-design/references/video-programatico.md) | HyperFrames, Remotion e Whisper (legendas) |
| ├─ [`references/3d-web.md`](skills/mestre-de-design/references/3d-web.md) | Three.js r187, React Three Fiber, drei, Rapier, Theatre.js, gltf-transform |
| ├─ [`references/motion-2d.md`](skills/mestre-de-design/references/motion-2d.md) | Rive, Lottie/dotLottie, PixiJS v8, Spine, Krita, OpenToonz |
| ├─ [`references/godot.md`](skills/mestre-de-design/references/godot.md) | Godot 4.7: animação, AnimationTree, Tween, pipeline Blender → Godot, export web, MCP |
| └─ [`references/animacao-personagem.md`](skills/mestre-de-design/references/animacao-personagem.md) | Alternativas gratuitas ao Cascadeur: Blender, Mixamo, Mesh2Motion, DeepMotion, Plask, FreeMoCap |
| [`skills/web-sem-cara-de-ia/`](skills/web-sem-cara-de-ia/SKILL.md) | Guia de decisão Three.js × GSAP × anime.js × Motion para sites |
| [`skills/vibecode-seguro/`](skills/vibecode-seguro/SKILL.md) | Protocolo spec-driven + auditoria de segurança de 9 pontos (antigo `SKILL Mestre.md`) |
| [`agents/mestre-de-design.md`](agents/mestre-de-design.md) | Subagente do Claude Code que usa a skill Mestre de Design |
| [`install.sh`](install.sh) | Instalador das skills e do agente |

## Instalação

```bash
git clone https://github.com/RenanVivas/Web-SemCara-De-IA.git
cd Web-SemCara-De-IA
./install.sh            # copia para ~/.claude/skills e ~/.claude/agents
./install.sh --link     # alternativa: symlinks, `git pull` atualiza na hora
./install.sh --project  # alternativa: só no projeto atual (./.claude)
```

Cursor, Windsurf, Codex e afins: copie o `SKILL.md` desejado como `AGENTS.md` ou regra do
editor. ChatGPT/Gemini: cole o conteúdo no início da conversa.

## Ferramentas externas recomendadas

```bash
# Anti-slop / gosto visual
npx impeccable install
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
npx skills@latest add emilkowalski/skills

# Vídeo programático
npx skills add heygen-com/hyperframes
npx skills add remotion-dev/skills

# Godot via MCP
claude mcp add godot -e GODOT_PATH=/Applications/Godot.app/Contents/MacOS/Godot -- npx @coding-solo/godot-mcp
```

Blender: MCP oficial do Blender Lab (add-on "MCP", Blender 5.1+).

## Mapa de ferramentas

| Área | Ferramentas |
|---|---|
| Composição e anti-slop | Impeccable, taste-skill, Emil Kowalski skills |
| Motion web | GSAP + ScrollTrigger, Lenis, anime.js v4, Motion (motion.dev) |
| 2D | Rive, Lottie/dotLottie, PixiJS v8, Spine, Krita, OpenToonz, Synfig |
| 3D web | Three.js, React Three Fiber, drei, Rapier, Theatre.js, Spline, gltf-transform |
| 3D e personagem | Blender, Mixamo, Mesh2Motion, DeepMotion, Plask, FreeMoCap |
| Jogos e interativo | Godot 4.7 (+ godot-mcp) |
| Vídeo | HyperFrames, Remotion, Whisper / whisper.cpp, FFmpeg |

## Créditos e fontes

- @ambrosiomkt — "4 ferramentas que uso pros meus sites não terem cara de IA" (base de `web-sem-cara-de-ia`)
- @miguelcandido.fbc — tutorial de HyperFrames, Impeccable, taste-skill, Remotion e Whisper
- @thiagor.designer — macetes de diagramação (base de `composicao-diagramacao.md`)
- Projetos: [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) ·
  [pbakaus/impeccable](https://github.com/pbakaus/impeccable) ·
  [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) ·
  [remotion-dev/remotion](https://github.com/remotion-dev/remotion) ·
  [ggml-org/whisper.cpp](https://github.com/ggml-org/whisper.cpp) ·
  [godotengine/godot](https://github.com/godotengine/godot) ·
  [Coding-Solo/godot-mcp](https://github.com/Coding-Solo/godot-mcp) ·
  [Mesh2Motion/mesh2motion-app](https://github.com/Mesh2Motion/mesh2motion-app) ·
  [freemocap/freemocap](https://github.com/freemocap/freemocap)
