# Anti-slop: tirando a "cara de IA"

Três ferramentas de agente que atacam o problema por ângulos diferentes. Use juntas: o
taste-skill direciona a criação, o Impeccable dá vocabulário e auditoria, as skills do
Emil Kowalski refinam motion e componentes.

## Impeccable — vocabulário de design + detector
Repositório: [pbakaus/impeccable](https://github.com/pbakaus/impeccable) · site: impeccable.style

```bash
npx impeccable install        # detecta Claude Code/Cursor/Codex; aceite o "design hook"
# no agente:
/impeccable init              # gera PRODUCT.md (público, objetivo, restrições)
/impeccable document          # captura o sistema visual atual em DESIGN.md
/impeccable critique the pricing cards
/impeccable bolder the hero
/impeccable polish settings
/impeccable live              # overlay no dev server para trocar variações ao vivo
```

Detector no terminal / CI:

```bash
npx impeccable detect src/                     # regras de padrão em JSX/TSX/HTML/CSS
npx impeccable detect http://localhost:5173    # regras que exigem página renderizada (contraste, texto minúsculo)
npx impeccable detect --github src/            # anotações no GitHub Actions
```

Código de saída `2` = encontrou problemas. Para liberar a fonte da marca:
`npx impeccable ignores add-value overused-font Inter --reason "Brand font"`.

## taste-skill — direção de arte com verificação no navegador
Repositório: [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) · Node 22+ e Chrome/Edge/Chromium

```bash
npx skills add https://github.com/Leonxlnx/taste-skill --skill "design-taste-frontend"
# ou no Claude Code: /plugin install taste-skill@taste-skill
```

Ideias centrais que vale adotar mesmo sem a skill: um sistema de design só, uma seção por
tela, fotos reais (ou stand-ins licenciados), ícones de marca reais, uma entrada de hero e
1–2 "momentos" por página, microinterações discretas, shaders e cenas de scroll só em
páginas de tech/games/software — e sempre um checker no navegador antes de entregar.

## Emil Kowalski skills — motion e componentes
Repositório: [emilkowalski/skills](https://github.com/emilkowalski/skills)

```bash
npx skills@latest add emilkowalski/skills
```

Útil para: escolher biblioteca de UI confiável em vez de reescrever componente, timing de
animação de interface, detalhes de interação.

## Lista de sinais de slop (revisão manual)

- Gradiente roxo→azul, glassmorphism em tudo, badge "✨ Powered by AI"
- 3 cards idênticos (ícone + título + 2 linhas) como seção de features
- Uma fonte só (Inter) sem hierarquia; tudo centralizado e simétrico
- Fotos de banco genéricas ou ilustração 3D "blob" sem relação com a marca
- Fade-in igual em todos os elementos; nenhuma reação a mouse/scroll
- Copy vaga ("Revolucione seu fluxo de trabalho"); CTA "Comece agora" repetido
- Ícones de linha genéricos no lugar de produto real, screenshot real ou foto real

## Fluxo recomendado

1. `/impeccable init` (contexto) → 2. criar com taste-skill ativo → 3. `npx impeccable detect`
na URL local → 4. `/impeccable critique` na seção mais importante → 5. corrigir → 6. screenshot
final em desktop e mobile.
