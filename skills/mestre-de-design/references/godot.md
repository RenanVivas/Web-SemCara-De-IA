# Godot Engine 4.7

Engine 2D/3D gratuita e open source (MIT), sem royalties. Versão estável atual: **4.7.2**.
Use para jogos, protótipos interativos, apps criativos, configuradores 3D e experiências que
precisam rodar nativo (Mac/Win/Linux/iOS/Android) e na web.

Download: godotengine.org · docs: docs.godotengine.org · repositório: [godotengine/godot](https://github.com/godotengine/godot)

## Quando Godot, quando web pura

| Godot | Three.js / PixiJS |
|---|---|
| Lógica de jogo, física, colisão, cenas, input complexo | Efeito visual dentro de um site |
| Editor visual de cena/animação para quem não é dev | Integração com DOM, SEO, formulários |
| Export nativo + web a partir do mesmo projeto | Peso mínimo de download |
| Animação de personagem com AnimationTree/state machine | Hero 3D decorativo |

## Agente + Godot (MCP)

```bash
# Claude Code — servidor MCP da comunidade (launch editor, rodar projeto, capturar debug)
claude mcp add godot -e GODOT_PATH=/Applications/Godot.app/Contents/MacOS/Godot -- npx @coding-solo/godot-mcp
```

Repositório: [Coding-Solo/godot-mcp](https://github.com/Coding-Solo/godot-mcp). Com ele o
agente roda o projeto, lê erros do console e itera. Sem MCP, o agente ainda pode editar
`.gd`, `.tscn` e `project.godot` (texto puro) e rodar `godot --headless --path . --quit`
para validar o projeto.

## Estrutura de projeto recomendada

```
res://
├── project.godot
├── scenes/        # .tscn (main.tscn, player.tscn, ui/…)
├── scripts/       # .gd
├── assets/
│   ├── models/    # .glb vindos do Blender
│   ├── sprites/
│   ├── audio/
│   └── fonts/
├── animations/    # .res de AnimationLibrary
└── shaders/       # .gdshader
```

Convenções GDScript: `snake_case` para funções/variáveis, `PascalCase` para classes e nós,
tipagem estática sempre (`var speed: float = 200.0`), sinais para desacoplar cenas.

## Animação no Godot — o que usar

| Necessidade | Nó/recurso |
|---|---|
| Animação keyframe de qualquer propriedade | `AnimationPlayer` |
| Transições de estado (idle → walk → run → jump) | `AnimationTree` + `AnimationNodeStateMachine` / `BlendSpace2D` |
| Animação simples por código (UI, juice) | `Tween` (`create_tween()`) |
| Sprite quadro a quadro | `AnimatedSprite2D` + `SpriteFrames` |
| Personagem 2D com ossos (cut-out) | `Skeleton2D` + `Bone2D` + `Polygon2D` |
| Personagem 3D | `Skeleton3D` importado de .glb + retarget humanoide |
| Ragdoll / física de ossos | `PhysicalBoneSimulator3D` + `PhysicalBone3D` |
| IK, look-at, ajustes procedurais | nós `SkeletonModifier3D` (ex.: `LookAtModifier3D`; confira os nós de IK disponíveis na sua versão) |
| Partículas | `GPUParticles2D/3D` |
| Câmera com movimento suave | `Camera2D` (position smoothing) / `Camera3D` + `Tween` |

### Juice com Tween (UI e feedback)

```gdscript
extends Button

func _ready() -> void:
	pivot_offset = size / 2
	mouse_entered.connect(_on_hover.bind(true))
	mouse_exited.connect(_on_hover.bind(false))

func _on_hover(entrou: bool) -> void:
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE * (1.06 if entrou else 1.0), 0.18)
```

### Personagem 3D com AnimationTree

```gdscript
extends CharacterBody3D

@export var speed: float = 5.0
@onready var anim_tree: AnimationTree = $AnimationTree

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("left", "right", "forward", "back")
	var dir := (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	# BlendSpace1D "locomotion" vai de 0 (idle) a 1 (run)
	anim_tree.set("parameters/locomotion/blend_position", velocity.length() / speed)
```

## Pipeline Blender → Godot

1. No Blender: aplique escala e rotação (`Ctrl+A`); não precisa girar eixos (o exportador
   glTF converte Z-up para Y-up); nomeie as ações (`idle`, `walk`, `run`) e marque *Fake User*.
2. Exporte **glTF Binary (.glb)** com animações (ou deixe o `.blend` na pasta do projeto —
   o Godot importa `.blend` direto se o caminho do Blender estiver configurado em
   *Editor Settings → FileSystem → Import → Blender*).
3. No Godot, aba *Import* → *Advanced*: para humanoides use **Retarget → BoneMap com
   `SkeletonProfileHumanoid`**; assim animações de Mixamo/Mesh2Motion funcionam em
   qualquer rig humanoide.
4. Sufixos de nome no Blender viram nós automaticamente: `-col` (colisão), `-loop`
   (animação em loop), `-rigid`, `-navmesh`.
5. Salve animações em `AnimationLibrary` (.res) para reaproveitar entre personagens.

## Export para web

- *Project → Export → Web*. Instale os templates de export da mesma versão do editor.
- Prefira **export single-threaded** (desmarque *Thread Support*): roda em qualquer host
  sem precisar de cabeçalhos COOP/COEP. Com threads, o servidor precisa enviar
  `Cross-Origin-Opener-Policy: same-origin` e `Cross-Origin-Embedder-Policy: require-corp`.
- Projetos em **C# não exportam para web** no Godot 4 — use GDScript se a web for alvo.
- Renderer *Compatibility* (WebGL 2) para máxima compatibilidade; *Forward+* só nativo.
- Comprima texturas (VRAM compression) e use `.glb` com meshopt para baixar menos.

## Checklist de entrega

- [ ] Roda sem erros no console (`godot --headless --path . --quit` para validar import)
- [ ] 60 fps no hardware alvo (Debugger → Monitors)
- [ ] Input remapeável e opção de reduzir movimento/tremor de câmera
- [ ] Export testado na plataforma final (web: abrir via servidor local, não `file://`)
