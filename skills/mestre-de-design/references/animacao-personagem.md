# Animação de personagem 3D — alternativas gratuitas ao Cascadeur

O Cascadeur combina pose assistida por IA e física em tempo real. Não existe um substituto
gratuito idêntico; o caminho é **combinar ferramentas** conforme a etapa.

## Comparativo

| Ferramenta | Melhor uso | Onde roda | Limite no grátis |
|---|---|---|---|
| **Blender** | Modelagem, rig, keyframe, controle total | Win/Mac/Linux | Nenhum (GPL, 100% grátis) |
| **Mixamo** (Adobe) | Auto-rig + biblioteca de movimentos prontos | Navegador | Precisa de conta Adobe; não edita keyframes; só humanoide bípede |
| **Mesh2Motion** | Alternativa open source ao Mixamo (humanos e criaturas, 120+ animações) | Navegador ou desktop | Nenhuma relevante — [Mesh2Motion/mesh2motion-app](https://github.com/Mesh2Motion/mesh2motion-app) |
| **DeepMotion Animate 3D** | Mocap a partir de vídeo comum | Navegador | Créditos/segundos mensais |
| **Plask** | Mocap a partir de vídeo + editor | Navegador | Créditos/exportações mensais |
| **FreeMoCap** | Mocap open source com webcams | Win/Mac/Linux | Nenhum (exige setup) |
| **Godot** | Física de ossos (ragdoll), IK em runtime, state machine | Win/Mac/Linux | Nenhum (MIT) |

## Pipeline recomendado

```
Modelo (Blender ou pronto)
   │
   ├─► Rig automático ──► Mixamo  ou  Mesh2Motion  (criaturas/quadrúpedes → Mesh2Motion)
   │                      └─ ou Rigify no Blender (controle total, rig de produção)
   │
   ├─► Movimento base ──► biblioteca pronta (Mixamo/Mesh2Motion)
   │                  └─► mocap de vídeo (DeepMotion/Plask/FreeMoCap) gravando você mesmo
   │
   ├─► Polimento ──────► Blender: NLA, Graph Editor, ajustes de pose, contato com o chão
   │
   └─► Destino ────────► .glb ──► Godot (AnimationTree) / Three.js (AnimationMixer)
```

## Recriando os "superpoderes" do Cascadeur no Blender

| Recurso do Cascadeur | Equivalente gratuito |
|---|---|
| AutoPosing (pose assistida) | Rig com IK (Rigify) + bibliotecas de pose (Pose Library, nativa) |
| AutoPhysics (física na animação) | Simulação Rigid Body para ragdoll; ou ragdoll em runtime com `PhysicalBoneSimulator3D` no Godot |
| Trajetórias e arcos | Motion Paths (Object/Pose → Motion Paths) e Graph Editor |
| Interpolação inteligente | Keyframes de pose-chave + modificadores de F-Curve (Cycles, Noise) |
| Retarget | Retarget humanoide no import do Godot (BoneMap) ou add-ons de retarget no Blender |

Add-ons pagos que aceleram (opcionais): Auto-Rig Pro. Prefira extensões do repositório
oficial extensions.blender.org.

## Blender com agente (MCP)

Use o **MCP oficial do Blender Lab** (add-on "MCP", Blender 5.1+; há conector Blender no
Claude). Com ele o agente inspeciona a cena, roda `bpy`, renderiza thumbnail e tira
screenshot da viewport. Regras ao operar via agente:

- Inspecione a cena antes de alterar (objetos, modificadores, materiais, coleções).
- Não destrua nada sem confirmação; prefira duplicar.
- Para animação via script, use `keyframe_insert(data_path=..., frame=...)` e confira no
  Graph Editor.

Evite clones de "Blender MCP" de contas desconhecidas no GitHub; o projeto comunitário
conhecido é `ahujasid/blender-mcp` (não oficial).

## Princípios para animação de personagem

- **Pose-chave primeiro** (blocking em *Constant*), depois breakdowns, depois spline.
- **Peso e contato:** pés não deslizam (use IK e marque frames de contato).
- **Arcos:** mãos e cabeça se movem em arco, nunca em linha reta.
- **Overlap e follow-through:** cabelo, roupa e cauda atrasam 2–4 frames em relação ao corpo.
- **Silhueta legível:** a pose tem que ler só pela sombra.
- **Loop limpo:** primeiro e último frame idênticos; ciclo de caminhada típico de 24–32 frames a 30 fps.
