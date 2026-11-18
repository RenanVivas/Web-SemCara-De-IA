---
name: web-sem-cara-de-ia
description: Use este skill sempre que iniciar um projeto novo de site, landing page, portfólio ou qualquer entregável de front-end (HTML, React, Webflow, WordPress) para evitar o visual genérico de "site feito por IA" — gradiente roxo, cards simétricos, glassmorphism e zero movimento. Traz um diagnóstico de anti-padrões visuais e um guia de decisão para quando usar Three.js, GSAP, anime.js e Motion (motion.dev) para dar profundidade, ritmo de scroll e personalidade ao invés de um layout estático de SaaS genérico. Consulte ANTES de estruturar o hero, as seções ou escrever qualquer CSS/animação — é passo de planejamento, não só de execução.
---

# Design Web Sem "Cara de IA"

> Baseado no reel de @ambrosiomkt "4 ferramentas que uso pros meus sites não terem cara de IA", expandido como guia de decisão prático para consulta no início de qualquer projeto de front-end. Complementa `sistema-animacao-web-v2.md` (que cobre GSAP, Lenis, IntersectionObserver e SplitText em profundidade).

## 1. Diagnóstico: como reconhecer a "cara de IA"

Antes de abrir o editor, revise esta lista mentalmente. Se o site que está prestes a construir bate 3+ pontos, pare e redesenhe antes de codar:

- Hero com gradiente roxo→azul (ou o inverso) como fundo padrão
- Grid de 3 cards idênticos: ícone + título em negrito + 2 linhas de descrição, repetido pra "features"
- Glassmorphism em tudo — blur + borda translúcida em cards que não precisam disso
- Badge de pílula com emoji: "🚀 Novo", "✨ Powered by AI"
- Tipografia única (Inter ou similar) em 100% do site, sem hierarquia expressiva
- Layout perfeitamente simétrico e centralizado, sem ritmo ou assimetria
- Zero movimento além de um fade-in genérico ao rolar
- Nenhuma reação a mouse/scroll: cursor padrão, sem parallax, sem profundidade
- Estrutura "SaaS landing page" copiada: Hero → Logos → Features → Pricing → CTA, sem narrativa

Esses padrões existem porque são o caminho de menor resistência do Tailwind + shadcn/ui puro. O problema não é usá-los — é usá-los sem nenhuma camada de movimento ou intenção por cima.

## 2. Guia de decisão: qual ferramenta resolve o quê

| Sintoma | Ferramenta | Resolve |
|---|---|---|
| Site "chapado", sem profundidade | **Three.js** | Cena 3D, WebGL, shader, fundo com volume |
| Página estática, sem narrativa ao rolar | **GSAP** + ScrollTrigger | Timeline, pin de seção, storytelling por scroll |
| Micro-interação "morta" (botão, ícone, SVG) | **anime.js v4** | Animação leve, stagger, morph de SVG, baixo peso |
| Projeto React/Vite/shadcn, precisa de UI fluida | **Motion** (motion.dev) | Animação declarativa, layout animation, gestos |

Não empilhe as 4 no mesmo projeto por padrão — escolha 1–2 dominantes conforme stack e objetivo (checklist na seção 7).

## 3. Three.js — profundidade e mundo 3D

**Usar quando:** hero com objeto 3D interativo, fundo com partículas/shader, showcase de produto, portfólio criativo.
**Evitar quando:** conteúdo é primariamente texto/formulário (SaaS B2B simples) — 3D vira ruído e peso de carregamento.

Setup via import map — funciona sem bundler, ideal pros protótipos single-file HTML:

```html
<script type="importmap">
{
  "imports": {
    "three": "https://cdn.jsdelivr.net/npm/three@0.187.0/build/three.module.js",
    "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.187.0/examples/jsm/"
  }
}
</script>
<script type="module">
  import * as THREE from 'three';

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(45, innerWidth / innerHeight, 0.1, 100);
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setSize(innerWidth, innerHeight);
  document.body.appendChild(renderer.domElement);

  const geo = new THREE.IcosahedronGeometry(1.4, 1);
  const mat = new THREE.MeshStandardMaterial({ color: 0xCBF83A, wireframe: true });
  const mesh = new THREE.Mesh(geo, mat);
  scene.add(mesh, new THREE.AmbientLight(0xffffff, 0.6), new THREE.DirectionalLight(0xffffff, 1));
  camera.position.z = 4;

  (function animate() {
    requestAnimationFrame(animate);
    mesh.rotation.x += 0.002;
    mesh.rotation.y += 0.003;
    renderer.render(scene, camera);
  })();
</script>
```

Cuidados: checar `prefers-reduced-motion` e limitar `pixelRatio` em mobile; nunca travar o thread principal — tudo dentro de `requestAnimationFrame`, nunca em loop síncrono.

## 4. GSAP — timeline e scroll storytelling

100% gratuito desde 2025, incluindo ScrollTrigger, SplitText, MorphSVG, DrawSVG e ScrollSmoother — sem mais plugins pagos. Cobertura completa em `sistema-animacao-web-v2.md`; aqui vai o essencial pra decisão rápida.

**Usar quando:** a seção precisa "contar uma história" enquanto o usuário rola — pin de seção, reveal sequenciado, parallax controlado.

```html
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.1/dist/gsap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.1/dist/ScrollTrigger.min.js"></script>
<script>
  gsap.registerPlugin(ScrollTrigger);

  gsap.timeline({
    scrollTrigger: { trigger: '.hero', start: 'top top', end: '+=800', scrub: 1, pin: true }
  })
  .from('.hero h1', { yPercent: 40, opacity: 0, ease: 'power3.out' })
  .from('.hero p', { yPercent: 20, opacity: 0, ease: 'power3.out' }, '-=0.4');
</script>
```

Em React: usar o hook `useGSAP()` do pacote `@gsap/react` — substitui `useEffect`/`useLayoutEffect` e cuida do cleanup automaticamente.

## 5. anime.js v4 — microinterações leves

Reescrito do zero na v4: modular, tree-shakeable, só com imports nomeados (o objeto global `anime` não existe mais).

**Usar quando:** botões, ícones, SVGs pequenos, stagger de listas/cards — qualquer coisa que não precise do peso de uma timeline complexa do GSAP.

```js
import { animate, stagger, splitText } from 'animejs';

// stagger simples num grid de cards
animate('.card', {
  translateY: [24, 0],
  opacity: [0, 1],
  delay: stagger(80, { from: 'first' }),
  ease: 'outQuint',
});

// texto quebrado por palavra, revelado com atraso
const split = splitText('.headline');
animate(split.words, { opacity: [0, 1], translateY: [10, 0], delay: stagger(30) });
```

Via CDN sem bundler: `<script src="https://cdn.jsdelivr.net/npm/animejs@4.5.0/dist/bundles/anime.umd.min.js"></script>` e usar `const { animate } = anime;`.

## 6. Motion (motion.dev) — animação declarativa em React

Antigo Framer Motion. O pacote agora é `motion`, e o import é `motion/react` — não use mais `framer-motion`.

**Usar quando:** projeto React/TS/Vite com shadcn/ui — layout animations, transições, gestos (hover/drag/tap), scroll-linked.

```tsx
import { motion, useScroll, useTransform } from 'motion/react';

function Hero() {
  const { scrollYProgress } = useScroll();
  const opacity = useTransform(scrollYProgress, [0, 0.3], [1, 0]);

  return (
    <motion.section
      style={{ opacity }}
      initial={{ y: 24, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.6, ease: 'easeOut' }}
    >
      <h1>Título</h1>
    </motion.section>
  );
}
```

Pra cards com stagger, usar `variants` + `staggerChildren`; pra morph entre estados, usar `layoutId` compartilhado (shared layout transition).

## 7. Checklist de início de projeto

Rodar antes de codar qualquer landing/site novo:

- [ ] Qual stack? (HTML single-file → CDN direto / React+Vite → npm)
- [ ] O site tem uma história pra contar ao rolar, ou é só listagem de info?
- [ ] Algum elemento merece profundidade 3D, ou isso seria ruído?
- [ ] CTAs, ícones e cards têm alguma microinteração, ou estão "mortos"?
- [ ] A tipografia tem hierarquia real, ou é tudo o mesmo peso/família?
- [ ] O layout tem alguma assimetria proposital, ou está tudo centralizado?
- [ ] `prefers-reduced-motion` está respeitado em todas as animações?

## 8. Regra de ouro

Motion serve à narrativa, não decora por decorar. Antes de empilhar as 4 ferramentas num projeto só, pergunte: essa animação ajuda o usuário a entender ou sentir algo, ou é só "porque dá pra fazer"? Um site com 1 animação certeira vale mais que 10 genéricas.

## 9. Veja também

- [`../mestre-de-design/SKILL.md`](../mestre-de-design/SKILL.md) — agente Mestre de Design: composição, 2D, 3D, vídeo programático e Godot.
- [`../mestre-de-design/references/anti-slop.md`](../mestre-de-design/references/anti-slop.md) — Impeccable e taste-skill para detectar e remover "AI slop" antes de entregar.
- [`../mestre-de-design/references/3d-web.md`](../mestre-de-design/references/3d-web.md) — Three.js com glTF, React Three Fiber, física e otimização de modelos.
