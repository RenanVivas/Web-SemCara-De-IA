# 3D na web: Three.js, React Three Fiber e companhia

Versões de referência (nov/2026): three `0.187.0` (r187) · @react-three/fiber `9.8` ·
@react-three/drei `10.7` · @react-three/rapier `2.2` · @theatre/core `0.7` · @gltf-transform/cli `4.5`.
Fixe a versão nos imports em produção — nunca `@latest`.

## Escolha

| Stack do projeto | Use |
|---|---|
| HTML single-file, landing estática | **Three.js** via import map |
| React / Next / Vite | **React Three Fiber** + **drei** |
| Precisa de física (queda, colisão, arrastar objetos) | **@react-three/rapier** (R3F) ou Rapier puro |
| Animação de câmera/objetos com timeline visual, keyframes editáveis | **Theatre.js** (`@theatre/core` + `@theatre/studio`, `@theatre/r3f`) |
| Cena feita por designer sem código | **Spline** (exporta para React/Vanilla) |
| Modelo vindo do Blender | glTF (.glb) otimizado com **gltf-transform** |

## Three.js puro (import map)

```html
<script type="importmap">
{ "imports": {
  "three": "https://cdn.jsdelivr.net/npm/three@0.187.0/build/three.module.js",
  "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.187.0/examples/jsm/"
} }
</script>
<script type="module">
  import * as THREE from 'three';
  import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
  import { MeshoptDecoder } from 'three/addons/libs/meshopt_decoder.module.js';

  const reduz = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
  renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
  renderer.setSize(innerWidth, innerHeight);
  document.body.appendChild(renderer.domElement);

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(40, innerWidth / innerHeight, 0.1, 100);
  camera.position.set(0, 1.2, 4);
  scene.add(new THREE.HemisphereLight(0xffffff, 0x222222, 1.2));

  const loader = new GLTFLoader().setMeshoptDecoder(MeshoptDecoder);
  const { scene: modelo, animations } = await loader.loadAsync('modelo.glb');
  scene.add(modelo);
  const mixer = new THREE.AnimationMixer(modelo);
  if (animations[0]) mixer.clipAction(animations[0]).play();

  const clock = new THREE.Clock();
  renderer.setAnimationLoop(() => {
    const dt = clock.getDelta();
    if (!reduz) mixer.update(dt);
    renderer.render(scene, camera);
  });
  addEventListener('resize', () => {
    camera.aspect = innerWidth / innerHeight; camera.updateProjectionMatrix();
    renderer.setSize(innerWidth, innerHeight);
  });
</script>
```

**WebGPU:** `import * as THREE from 'three/webgpu'` + `WebGPURenderer` e shaders em TSL
(`three/tsl`). Use quando precisar de compute/partículas massivas; mantenha fallback
WebGL (o próprio `WebGPURenderer` cai para WebGL 2 quando não há suporte).

## React Three Fiber + drei

```tsx
import { Canvas } from '@react-three/fiber';
import { Environment, Float, OrbitControls, useGLTF, ContactShadows } from '@react-three/drei';

function Produto() {
  const { scene } = useGLTF('/produto.glb');
  return <Float speed={1.4} rotationIntensity={0.4}><primitive object={scene} /></Float>;
}

export function Hero3D() {
  return (
    <Canvas dpr={[1, 2]} camera={{ position: [0, 1, 4], fov: 40 }}>
      <Environment preset="studio" />
      <Produto />
      <ContactShadows position={[0, -1, 0]} opacity={0.4} blur={2.5} />
      <OrbitControls enableZoom={false} />
    </Canvas>
  );
}
useGLTF.preload('/produto.glb');
```

Scroll 3D: `ScrollControls` + `useScroll` do drei, ou GSAP ScrollTrigger animando um
`ref` da câmera. Física: envolva com `<Physics>` do `@react-three/rapier` e use `<RigidBody>`.

## Otimizando modelos (obrigatório)

```bash
npx @gltf-transform/cli optimize entrada.glb saida.glb --compress meshopt --texture-compress webp
npx @gltf-transform/cli inspect saida.glb      # confira contagem de triângulos e tamanho de texturas
```

Metas: hero < 3 MB, texturas ≤ 2048 px, < 200 k triângulos em mobile. Use KTX2 quando
houver muitas texturas (requer `toktx` instalado).

## Checklist 3D

- [ ] `pixelRatio` limitado a 2; render pausado quando o canvas sai da tela (IntersectionObserver)
- [ ] `prefers-reduced-motion` desliga rotação automática/parallax
- [ ] Fallback (imagem estática) se WebGL falhar ou em conexão lenta
- [ ] O 3D tem função narrativa (mostrar produto, criar mundo) — não é só enfeite
- [ ] Texto importante continua em HTML (acessível e indexável), nunca dentro do canvas
