# Motion e animação 2D

Versões de referência (nov/2026): gsap `3.15` · animejs `4.5` · motion `14.14` · lenis `1.3` ·
pixi.js `8.23` · @rive-app/canvas `2.51` · @lottiefiles/dotlottie-web `0.83`.

Para GSAP, anime.js e Motion na construção de sites, siga
[`../../web-sem-cara-de-ia/SKILL.md`](../../web-sem-cara-de-ia/SKILL.md). Esta página cobre o
resto do universo 2D.

## Escolha

| Necessidade | Ferramenta | Por quê |
|---|---|---|
| Ícone/mascote/botão com estados (hover, loading, sucesso) | **Rive** | State machine embutida, arquivo leve, runtime web/iOS/Android/Flutter/Unity |
| Animação feita no After Effects | **Lottie / dotLottie** | Export via Bodymovin ou LottieFiles; `.lottie` é compactado |
| Muitos sprites, partículas, jogo 2D na web | **PixiJS v8** | Renderização WebGL/WebGPU, milhares de objetos a 60 fps |
| Jogo 2D completo, nativo + web | **Godot** (ver `godot.md`) | Física, cenas, Skeleton2D, AnimationPlayer |
| Personagem 2D com ossos (cut-out) | Godot `Skeleton2D` (grátis) · **Spine** (pago, padrão da indústria) · DragonBones (grátis, sem manutenção ativa) | |
| Animação quadro a quadro desenhada | **Krita** (grátis) · **OpenToonz** (grátis, usado em estúdio) · Blender **Grease Pencil** | |
| Vetor animado sem código | **Synfig** (grátis) | |
| Rolagem suave para cenas de scroll | **Lenis** | Combina com GSAP ScrollTrigger |

## Rive (web)

```html
<canvas id="mascote" width="400" height="400"></canvas>
<script src="https://cdn.jsdelivr.net/npm/@rive-app/canvas@2.51.0"></script>
<script>
  const mascote = document.getElementById('mascote');
  const r = new rive.Rive({
    src: 'mascote.riv',
    canvas: mascote,
    stateMachines: 'Principal',
    autoplay: true,
    onLoad: () => {
      r.resizeDrawingSurfaceToCanvas();
      const inputs = r.stateMachineInputs('Principal');
      const hover = inputs.find(i => i.name === 'hover');
      mascote.addEventListener('mouseenter', () => (hover.value = true));
      mascote.addEventListener('mouseleave', () => (hover.value = false));
    },
  });
</script>
```

React: pacote `@rive-app/react-canvas` (`useRive`, `useStateMachineInput`).

## dotLottie (web)

```html
<canvas id="anim" style="width:240px;height:240px"></canvas>
<script type="module">
  import { DotLottie } from 'https://cdn.jsdelivr.net/npm/@lottiefiles/dotlottie-web@0.83.2/+esm';
  const reduz = matchMedia('(prefers-reduced-motion: reduce)').matches;
  new DotLottie({ canvas: document.getElementById('anim'), src: 'icone.lottie', loop: !reduz, autoplay: !reduz });
</script>
```

## PixiJS v8

```js
import { Application, Assets, Sprite } from 'pixi.js';

const app = new Application();
await app.init({ resizeTo: window, background: '#0d0d0d', antialias: true });
document.body.appendChild(app.canvas);

const textura = await Assets.load('estrela.png');
const estrelas = Array.from({ length: 400 }, () => {
  const s = new Sprite(textura);
  s.anchor.set(0.5);
  s.position.set(Math.random() * app.screen.width, Math.random() * app.screen.height);
  s.scale.set(0.2 + Math.random() * 0.4);
  app.stage.addChild(s);
  return s;
});
app.ticker.add(({ deltaTime }) => {
  for (const s of estrelas) s.rotation += 0.01 * deltaTime;
});
```

Na v8 o `init` é assíncrono e o canvas é `app.canvas` (não mais `app.view`).

## Princípios de motion 2D

- **Antecipação e overshoot** dão vida: um botão que encolhe 2% antes de crescer.
- **Stagger** em listas (40–80 ms entre itens), nunca todos ao mesmo tempo.
- **Easing por intenção:** entrada `outQuint`/`power3.out`, saída `inQuad` mais curta, elástico só em momentos lúdicos.
- **Loop discreto:** animações ociosas (idle) com amplitude pequena e período longo (3–6 s).
- **Estados claros:** todo componente animado tem estado de repouso legível sem animação.
