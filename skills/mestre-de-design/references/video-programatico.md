# Vídeo programático: HyperFrames, Remotion e Whisper

> Baseado no reel de @miguelcandido.fbc "tutorial do claude hyperframes", que mostra
> HyperFrames, Impeccable, taste-skill, Remotion e Whisper como kit de criação de vídeo
> com agente.

## Qual usar

| Situação | Escolha |
|---|---|
| Agente vai escrever o vídeo do zero; quer HTML puro, sem build | **HyperFrames** |
| Projeto já é React; templates paramétricos com props e dados | **Remotion** |
| Uso comercial em empresa com mais de 3 pessoas, sem orçamento de licença | **HyperFrames** (Apache 2.0, sem taxa por render) |
| Precisa de legenda/transcrição | **Whisper** (ou whisper.cpp) + qualquer um dos dois |
| Migrar projeto Remotion existente para HTML | skill `/remotion-to-hyperframes` |

## HyperFrames (HeyGen) — HTML vira MP4
Repositório: [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) · Apache 2.0 · Node 22+ e FFmpeg

```bash
# Skills para o agente (Claude Code)
claude plugin marketplace add heygen-com/hyperframes
claude plugin install hyperframes@hyperframes
# ou standalone:
npx skills add heygen-com/hyperframes        # escolha o grupo "Core Skills"

# Projeto manual
npx hyperframes init meu-video && cd meu-video
npx hyperframes preview                       # preview com live reload
npx hyperframes render                        # MP4 final
npx hyperframes add data-chart                # bloco pronto do catálogo (~450 blocos)
```

Uma composição é HTML com atributos de tempo; a animação precisa ser **seekável**
(timeline pausada registrada em `window.__timelines`):

```html
<div id="stage" data-composition-id="post" data-start="0" data-width="1080" data-height="1920">
  <img class="clip" src="foto.jpg" data-start="0" data-duration="6" data-track-index="0">
  <h1 id="title" class="clip" data-start="0.5" data-duration="5" data-track-index="1">
    A vida mais doce é não pensar em nada.
  </h1>
  <script src="https://cdn.jsdelivr.net/npm/gsap@3/dist/gsap.min.js"></script>
  <script>
    const tl = gsap.timeline({ paused: true });
    tl.from('#title', { yPercent: 30, opacity: 0, duration: 0.8, ease: 'power3.out' }, 0.5);
    window.__timelines = window.__timelines || {};
    window.__timelines.post = tl;
  </script>
</div>
```

Dicas:
- Aplique `composicao-diagramacao.md` no CSS: posicione `#title` pelo terço oposto ao
  ponto de interesse da foto e respeite as zonas seguras do 9:16.
- Renderização é determinística (Chrome headless + FFmpeg): ótimo para gerar 30 variações
  em CI trocando só texto e imagem.
- `frame.md` (hyperframes.studio/design) traduz o design system da marca para vídeo.

## Remotion — vídeo em React
Repositório: [remotion-dev/remotion](https://github.com/remotion-dev/remotion) · skills: [remotion-dev/skills](https://github.com/remotion-dev/skills)

**Licença:** gratuita para pessoa física e empresas com até 3 funcionários; acima disso
exige licença de empresa. Confirme em remotion.dev/license antes de usar em cliente.

```bash
npx create-video@latest --skills      # cria projeto e instala as skills do agente
npx remotion studio                   # editor no navegador
npx remotion render MinhaComp out/video.mp4
```

```tsx
import { AbsoluteFill, Composition, interpolate, spring, useCurrentFrame, useVideoConfig } from 'remotion';

const Titulo: React.FC<{ texto: string }> = ({ texto }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const entrada = spring({ frame, fps, config: { damping: 200 } });
  const y = interpolate(entrada, [0, 1], [60, 0]);
  return (
    <AbsoluteFill style={{ padding: 96, justifyContent: 'flex-start' }}>
      <h1 style={{ transform: `translateY(${y}px)`, opacity: entrada, fontSize: 120, maxWidth: '60%' }}>
        {texto}
      </h1>
    </AbsoluteFill>
  );
};

export const Root = () => (
  <Composition id="MinhaComp" component={Titulo} durationInFrames={150} fps={30}
    width={1080} height={1920} defaultProps={{ texto: 'Chega um momento…' }} />
);
```

Use `<Sequence from={...}>` para encadear cenas e `calculateMetadata` para duração
dinâmica a partir de dados.

## Whisper — legenda e transcrição
- [openai/whisper](https://github.com/openai/whisper) (Python) ou
  [ggml-org/whisper.cpp](https://github.com/ggml-org/whisper.cpp) (C/C++, rápido no Mac com Metal).
- No Remotion: pacote `@remotion/install-whisper-cpp` (`installWhisperCpp`,
  `downloadWhisperModel`, `transcribe`, `toCaptions`) + `@remotion/captions`
  (`createTikTokStyleCaptions`) para legenda palavra-a-palavra.
- No HyperFrames: a skill `/media-use` cuida de transcrição e legendas; o catálogo tem
  blocos de legenda cinética.

Pipeline manual com whisper.cpp:

```bash
ffmpeg -i entrada.mp4 -ar 16000 -ac 1 -c:a pcm_s16le audio.wav
whisper-cli -m models/ggml-large-v3-turbo.bin -f audio.wav -l pt -osrt -ojf   # gera .srt e JSON com timestamps
```

## Formatos de entrega

| Plataforma | Tamanho | FPS | Observação |
|---|---|---|---|
| Reels / TikTok / Shorts | 1080×1920 | 30 | Zonas seguras: ~200 px topo, ~250 px base, ~120 px direita |
| Feed 4:5 | 1080×1350 | 30 | Primeiro frame precisa funcionar como capa |
| YouTube | 1920×1080 ou 3840×2160 | 30/60 | H.264 ou H.265, áudio AAC 48 kHz |

Checklist: primeiro segundo com gancho visual, legenda legível sem som, contraste da
legenda sobre qualquer frame, música licenciada, loudness ~ −14 LUFS.
