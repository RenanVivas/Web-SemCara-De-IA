# Composição e diagramação

> Baseado no reel de @thiagor.designer "Alguns macetes de diagramação", expandido como
> procedimento para posts, carrosséis, capas, thumbnails e heros de site.

## Procedimento em 6 passos

1. **Leia a imagem primeiro.** Onde está o sujeito? Para onde ele olha ou se move? Onde há
   área vazia e de contraste uniforme? Essa área é o lugar natural do texto.
2. **Decida: tensão ou simetria.** O padrão é tensão (texto fora do centro). Simetria é
   exceção consciente (passo 6).
3. **Posicione pelo grid de terços.** Coloque o bloco de texto encostado em um cruzamento
   dos terços e o ponto de interesse da foto no cruzamento oposto.
4. **Respeite a direção do olhar e do movimento.** Deixe espaço à frente do sujeito.
5. **Separe título e parágrafo.** Cada um ocupa seu próprio espaço.
6. **Revise margem, hierarquia e leitura em 1 segundo.**

## As regras, uma a uma

### 1. Tensão: tire o texto do centro
Texto centralizado num fundo neutro fica estável — e sem graça. Puxe o bloco do centro
em direção a um canto (ex.: superior esquerdo) e **limpe o lado oposto**. O vazio
contrapõe o peso do texto e cria tensão visual. Se houver foto, ela ocupa o lado limpo.

### 2. Regra dos terços
Divida a peça em 3×3. Os 4 cruzamentos são pontos de força.
- Texto alinhado a um cruzamento (normalmente um dos superiores).
- Elemento de interesse da foto — **o olho do personagem**, o rosto, o produto — no
  **cruzamento oposto** (diagonal). Isso equilibra a peça sem centralizar.
- Vale na horizontal e na vertical: o bloco de texto pode ocupar exatamente um terço.

### 3. Espaço na direção do olhar
Se o sujeito está de perfil olhando para a direita, o espaço respirável e o texto ficam
**à frente do olhar** (à direita). Colocar o texto atrás da cabeça "corta" o olhar e a
peça parece apertada. Alternativa: deixar essa área vazia e usar a própria foto como
protagonista.

### 4. Não cole texto na borda
Texto encostado na borda do post parece erro. Defina margem segura:
- Feed 1080×1350: margem mínima de ~80 px (≈ 7%).
- Reels/Stories 1080×1920: evitar os ~250 px de baixo (legenda/UI) e ~200 px de cima;
  ~120 px à direita por causa dos botões.
- Site: margens horizontais fluidas (`clamp(16px, 5vw, 96px)`).

### 5. Título e parágrafo em espaços diferentes
Experimente reservar espaços distintos: o título grande e pesado num terço; o parágrafo
menor, **alinhado à esquerda**, em outra área (ex.: canto inferior direito). Parágrafo
centralizado com muitas linhas cansa a leitura. Vá sempre ajustando posição e tamanho até
os dois blocos conversarem sem competir.

### 6. Centralize às vezes — por escolha
Centralizar funciona muito bem quando a **foto é simétrica e o sujeito está de frente**
(retrato frontal, objeto no eixo). Aí o título central reforça a simetria. A regra é: você
centraliza porque escolheu, não porque foi o padrão da ferramenta.

## Tipografia para peças sociais

- 1 família display condensada/pesada para título + 1 sans legível para texto. Caixa alta
  só em títulos curtos (≤ 6 palavras).
- Título ≥ 2× o tamanho do parágrafo. Entrelinha do título apertada (0.9–1.05), do
  parágrafo confortável (1.3–1.5).
- Quebra de linha manual no título: cada linha uma ideia, sem viúvas ("a", "e" sozinhos).
- Assinatura/@ pequena, discreta, alinhada a uma margem — nunca competindo com o título.

## Foto e tratamento

- P&B ou paleta restrita dá unidade a um carrossel inteiro.
- Escureça/clareie só a área onde o texto vai (gradiente localizado), não a foto toda.
- Motion blur e granulação dão textura editorial; use com intenção, não como filtro padrão.

## Checklist rápida

- [ ] Texto fora do centro, ou centralização justificada por foto simétrica/frontal
- [ ] Ponto de interesse da foto em cruzamento oposto ao texto
- [ ] Espaço à frente do olhar/movimento do sujeito
- [ ] Margem segura respeitada em todos os lados (e zonas de UI no 9:16)
- [ ] Título e parágrafo em áreas distintas; parágrafo alinhado à esquerda
- [ ] Lido em 1 segundo na tela do celular

## Automatizando (HTML → imagem/vídeo)

Para gerar variações (carrossel de 10 cards, 30 versões de anúncio), monte a peça em
HTML/CSS com variáveis de layout (`--text-x`, `--text-y`, `--title-size`) e renderize com
HyperFrames ou Remotion (ver `video-programatico.md`). Regras desta página viram
parâmetros: posição do texto pelo terço oposto ao `focus` da foto.
