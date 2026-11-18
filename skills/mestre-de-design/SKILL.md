---
name: mestre-de-design
description: Agente Mestre de Design — direção de arte e produção de motion, 2D, 3D, vídeo programático e jogos. Use SEMPRE que a tarefa envolver criar ou revisar peça visual, post, carrossel, capa, landing page, animação web, vídeo (Reels, Shorts, anúncio, legenda animada), cena 3D, personagem animado, rig, mocap, sprite 2D, jogo ou protótipo interativo — mesmo quando o pedido for só "deixa bonito", "anima isso", "faz um vídeo", "monta um post", "cria uma cena 3D", "quero isso no Godot" ou "tá com cara de IA". Escolhe a ferramenta certa (Godot, Blender, Three.js/R3F, Rive, Lottie, PixiJS, GSAP, Motion, Remotion, HyperFrames, Whisper, Mixamo, Mesh2Motion), aplica regras de composição e diagramação e passa a entrega por checagem anti-"AI slop" antes de dar como pronta.
---

# Mestre de Design

> Orquestrador de design visual e movimento. Este arquivo decide **o quê** e **com o quê**;
> os detalhes de cada ferramenta ficam em `references/` e só devem ser lidos quando a
> tarefa precisar deles.

| Referência | Ler quando |
|---|---|
| [`references/composicao-diagramacao.md`](references/composicao-diagramacao.md) | Qualquer peça com texto + imagem: post, carrossel, capa, hero, thumbnail |
| [`references/anti-slop.md`](references/anti-slop.md) | Antes de entregar qualquer UI/site; ao instalar Impeccable, taste-skill, Emil Kowalski skills |
| [`references/motion-2d.md`](references/motion-2d.md) | Microinteração, ícone animado, mascote, UI animada, sprite, animação vetorial |
| [`references/3d-web.md`](references/3d-web.md) | Cena 3D no navegador, produto 3D, partículas, shader, scroll 3D |
| [`references/godot.md`](references/godot.md) | Jogo, protótipo interativo, app 2D/3D nativo ou web, qualquer menção a Godot |
| [`references/animacao-personagem.md`](references/animacao-personagem.md) | Personagem 3D: rig, pose, keyframe, física, mocap — alternativas ao Cascadeur |
| [`references/video-programatico.md`](references/video-programatico.md) | Vídeo gerado por código: Reels, Shorts, anúncio, legenda animada, template de vídeo |
| [`../web-sem-cara-de-ia/SKILL.md`](../web-sem-cara-de-ia/SKILL.md) | Site/landing: quando usar Three.js, GSAP, anime.js ou Motion |
| [`../vibecode-seguro/SKILL.md`](../vibecode-seguro/SKILL.md) | Qualquer entrega que vá pra produção (spec + auditoria de segurança) |

---

## 1. Fluxo de trabalho (sempre nesta ordem)

1. **Brief em 5 linhas** — antes de abrir qualquer ferramenta, escreva:
   - Peça: o que é e onde vai aparecer (feed 4:5, Reels 9:16, desktop 16:9, jogo, site).
   - Público e sensação: 3 adjetivos concretos ("cru, editorial, noturno" — nunca "moderno e clean").
   - Mensagem única: a frase que a pessoa precisa lembrar.
   - Restrições: marca, fontes, prazo, peso, plataforma, licença.
   - Critério de pronto: como saber que acabou (ex.: "lê em 1 s no celular", "60 fps em mobile médio").
2. **Escolher o meio** com a matriz da seção 2. Uma ferramenta dominante + no máximo uma de apoio.
3. **Compor antes de animar** — resolva a peça parada primeiro (seção 3 e
   `composicao-diagramacao.md`). Movimento ruim não salva composição ruim.
4. **Executar** lendo só a referência do meio escolhido.
5. **Verificar** com a checklist da seção 5. Nada é "pronto" sem ver renderizado (navegador,
   screenshot, frame do vídeo, jogo rodando).
6. **Entregar** com: o que foi feito, ferramenta usada e por quê, como editar depois, o que não foi verificado.

## 2. Matriz de decisão: qual ferramenta

| Preciso de… | Ferramenta principal | Apoio | Evitar |
|---|---|---|---|
| Post/carrossel/capa estática | Composição + Figma/Penpot ou HTML→PNG | HyperFrames (exportar frame) | Template genérico centralizado |
| Site com narrativa ao rolar | GSAP + ScrollTrigger | Lenis, SplitText | Animar tudo que aparece |
| UI React fluida | Motion (`motion/react`) | Emil Kowalski skills | `framer-motion` (pacote antigo) |
| Microinteração leve / SVG | anime.js v4 | Lottie | GSAP pesado pra um botão |
| Ícone/mascote animado com estados | **Rive** (state machine) | Lottie/dotLottie | GIF |
| Animação vetorial vinda do After Effects | **Lottie / dotLottie** | — | Vídeo MP4 pra ícone |
| Jogo 2D ou cena 2D com muitos sprites na web | **PixiJS v8** ou **Godot (export web)** | Spine / Skeleton2D | DOM com centenas de nós |
| Cena 3D no site | **Three.js** (HTML puro) ou **React Three Fiber** (React) | drei, Rapier, Theatre.js | 3D em página de formulário |
| Objeto/produto 3D de alta qualidade | **Blender** → glTF → Three.js/Godot | gltf-transform | Modelo bruto sem compressão |
| Jogo, protótipo interativo, app criativo nativo | **Godot 4.7** | Blender, Godot MCP | Reinventar engine em JS |
| Personagem 3D animado | **Blender** + Mixamo/Mesh2Motion | DeepMotion/Plask (mocap de vídeo) | Keyframe manual de ciclo de corrida do zero |
| Vídeo curto com texto/dados/legenda | **HyperFrames** (HTML/GSAP) | Whisper (legenda) | Editor manual pra 30 variações |
| Vídeo em React, templates paramétricos | **Remotion** | `@remotion/install-whisper-cpp` | Remotion sem checar licença em empresa |
| Legenda/transcrição | **Whisper** / whisper.cpp | ffmpeg | Legenda digitada à mão |

Regra: se duas ferramentas resolvem, escolha a que **já está no stack do projeto**.

## 3. Princípios de composição (resumo — detalhes na referência)

- **Tensão > centro.** Puxe o bloco de texto do centro em direção a uma borda e deixe o lado oposto limpo. Centralize só por escolha: foto simétrica, sujeito de frente, título curto e forte.
- **Regra dos terços com intenção.** Texto num cruzamento, ponto de interesse da foto (o olho, o rosto) no cruzamento oposto.
- **Espaço na direção do olhar.** Se o sujeito olha para a direita, o espaço respirável — e o texto — vai para a direita.
- **Margem é sagrada.** Nunca cole texto na borda do post. Defina margem segura (≥ 6–8% da largura) e respeite as zonas de UI do Reels/Stories.
- **Título e parágrafo vivem em espaços diferentes.** Título grande e com peso; parágrafo menor, alinhado à esquerda, ocupando outra área — nunca o mesmo bloco centralizado com tudo junto.
- **Hierarquia tipográfica real.** No máximo 2 famílias; contraste de tamanho ≥ 2×; peso e caixa variando com propósito.
- **Fotografia comanda.** Leia a foto antes de posicionar o texto: linhas, direção, vazio, contraste. O texto ocupa o vazio que a foto já oferece.

## 4. Princípios de movimento

- **Movimento serve à narrativa.** Toda animação responde: o que ela ensina ou faz sentir? Se a resposta for "nada", corte.
- **Uma cena-assinatura por peça** (hero, transição de seção, reveal do produto). O resto é discreto.
- **Easing com caráter:** entradas com `power3.out`/`outQuint`, saídas mais rápidas que entradas; nada de `linear` em UI.
- **Duração:** UI 150–300 ms; transição de seção 500–900 ms; cena-assinatura até 1,5 s.
- **12 princípios da animação** valem em tudo, inclusive UI: antecipação, follow-through, arcos, squash & stretch sutil, timing.
- **Acessibilidade:** respeite `prefers-reduced-motion` (web) e ofereça opção de reduzir movimento (jogo).
- **Performance:** anime só `transform` e `opacity` no DOM; em 3D limite `pixelRatio` (≤ 2) e use `requestAnimationFrame`/`_process`, nunca loop síncrono.

## 5. Checklist de verificação antes de entregar

- [ ] Vi a peça renderizada (screenshot, frame do vídeo, jogo rodando) — não só o código.
- [ ] Passa no teste de 1 segundo no celular: mensagem principal legível sem zoom.
- [ ] Composição: texto fora do centro (ou centralização justificada), margem segura respeitada.
- [ ] Hierarquia: título, apoio e CTA distinguíveis em escala de cinza.
- [ ] Anti-slop: rodei `npx impeccable detect` (UI web) ou revisei a lista de `anti-slop.md`.
- [ ] Movimento: nenhuma animação sem propósito; `prefers-reduced-motion` tratado.
- [ ] Performance: 60 fps no alvo; assets 3D comprimidos (Draco/meshopt + KTX2); vídeo no codec/tamanho da plataforma.
- [ ] Licenças: fontes, fotos, modelos 3D, músicas e ferramentas (Remotion em empresa, Mixamo, Spine) conferidos.
- [ ] Editável: alguém consegue mudar texto/cor/duração sem reescrever (variáveis, props, tokens).

## 6. Ferramentas de agente recomendadas (instalação)

```bash
# Anti-slop e gosto visual
npx impeccable install                                                   # depois: /impeccable init
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
npx skills@latest add emilkowalski/skills

# Vídeo programático
npx skills add heygen-com/hyperframes                                    # ou: npx hyperframes skills update
npx skills add remotion-dev/skills                                       # dentro de projeto Remotion: npx remotion skills add

# Godot via MCP (Claude Code)
claude mcp add godot -e GODOT_PATH=/Applications/Godot.app/Contents/MacOS/Godot -- npx @coding-solo/godot-mcp
```

Blender: use o **MCP oficial do Blender Lab** (add-on "MCP", Blender 5.1+; conector Blender no Claude).
Evite clones de "Blender MCP" de contas desconhecidas no GitHub — vários são cópias com nome inflado.

## 7. Regra de ouro

Primeiro a ideia, depois a composição, por último o movimento. Uma peça com uma decisão
corajosa e bem executada vale mais que dez efeitos empilhados.
