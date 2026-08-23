---
name: vibecode-seguro
description: Protocolo de operação de agentes de IA (spec-driven, critério de sucesso, edições cirúrgicas) somado a uma auditoria de segurança de 9 pontos para aplicações SaaS e web. Use SEMPRE que a conversa envolver construir, revisar, refatorar ou colocar no ar qualquer app, SaaS, landing page, API ou automação — inclusive quando o usuário só disser "faz isso pra mim", "cria essa tela", "termina esse projeto", "revisa meu código" ou "tá pronto pra subir?". Use também quando aparecer vibecoding, Claude Code, LangChain, spec driven, Graphify, chaves de API, .env, login, autenticação, JWT, CORS, rate limit ou banco de dados. Não espere o usuário pedir "segurança" ou "spec" explicitamente.
---

# Vibecode Seguro

> **Como usar este arquivo**
>
> - **Claude Code / Claude:** copie para `~/.claude/skills/vibecode-seguro/SKILL.md`.
> - **Cursor, Windsurf, Codex, Zed, Aider:** copie para a raiz do projeto como
>   `AGENTS.md`, `.windsurfrules` ou `.cursor/rules/vibecode-seguro.mdc` —
>   o conteúdo é o mesmo, só muda o nome do arquivo.
> - **ChatGPT, Gemini ou qualquer chat:** cole o documento inteiro no início
>   da conversa, ou salve como instrução personalizada.

**Índice**

- [Parte I — Protocolo](#parte-i--protocolo) · as 4 fases do trabalho
- [Parte II — Auditoria de segurança](#parte-ii--auditoria-de-segurança-em-detalhe) · as 9 vulnerabilidades
- [Parte III — Operando agentes](#parte-iii--operando-agentes-de-código) · onde o agente erra e onde é imbatível
- [Parte IV — Ferramentas](#parte-iv--ferramentas) · Graphify, Spec Driven, LangChain

---

# Parte I — Protocolo

Construir com agente é rápido. O problema é que a velocidade esconde duas
falhas caras: o agente executa antes de entender, e o que ele entrega vai
pra produção com buracos de segurança que ninguém revisou.

Esta skill existe pra fechar os dois lados: **como conduzir o agente** e
**o que auditar antes de entregar**.

## Quando aplicar o quê

| Situação | O que fazer |
|---|---|
| Tarefa nova, escopo maior que um arquivo | Fase 1 (Spec) → Fase 2 (Execução) |
| Ajuste pontual em código existente | Fase 3 (Cirurgia) |
| Antes de subir pra produção / entregar pro cliente | Fase 4 (Auditoria) |
| Feature de IA no produto | Ler a Parte IV deste documento |
| Codebase grande ou desconhecido | Rodar Graphify antes da Fase 1 — a Parte IV deste documento |

---

## Fase 1 — Spec antes de código

O erro número um do agente é executar sem contexto: ele não entende a
tarefa, não pede mais informação, e sai fazendo. O resultado parece certo
e está errado por dentro.

A correção é inverter a ordem: **a spec é o artefato, o código é a
consequência.**

Antes de escrever qualquer linha, produza um bloco curto assim:

```markdown
## Objetivo
Uma frase. O que o usuário consegue fazer no final que não conseguia antes.

## Critério de sucesso
- [ ] Verificável, não vago. "Login bloqueia após 5 tentativas" e não "login seguro".
- [ ] Cada item precisa ser testável por alguém que não escreveu o código.

## Fora de escopo
O que explicitamente NÃO será tocado nesta tarefa.

## Restrições
Stack, arquivos que podem ser alterados, o que não pode quebrar.
```

Regras de conduta nesta fase:

- **Pergunte antes de assumir.** Se houver mais de uma leitura razoável do
  pedido, levante a ambiguidade em vez de escolher uma em silêncio. Um agente
  que assume errado e segue em frente custa mais caro que um que pergunta.
- **Aponte inconsistências.** Se o pedido conflita com o que já existe no
  projeto, diga isso. Não contorne por educação.
- **Apresente o trade-off.** Quando houver duas abordagens viáveis, mostre as
  duas com custo e consequência, e recomende uma.
- **Discorde quando for o caso.** Concordar com tudo não é ajudar.

Em repositório grande ou herdado, monte o contexto antes de escrever a spec:
o Graphify mapeia o código num grafo consultável, e o agente passa a
responder por caminho auditável em vez de reconstruir a arquitetura a cada
sessão. Fluxo e detalhe do spec-driven na Parte IV.

---

## Fase 2 — Execução com critério de sucesso

O agente não tem objetivo próprio. Sem critério de sucesso, ele faz trabalho
por trabalho: entrega volume em vez de resultado.

**Não diga o que fazer. Dê o alvo e deixe o agente iterar até bater.**

- Escreva o teste primeiro, depois faça o código passar.
- Coloque o agente no loop com algo que verifica sozinho (teste, build,
  linter, MCP de browser). Loop fechado > instrução detalhada.
- Escreva primeiro a versão ingênua e claramente correta; só depois otimize
  preservando o comportamento.
- Prefira o declarativo ("este é o estado final desejado") ao imperativo
  ("faça o passo A, depois o B"). Declarativo mantém o agente iterando
  sozinho por mais tempo.

### Antídoto para o excesso

Agente complica. Você pede um processo simples e recebe 15 passos; pede um
documento enxuto e recebe 10 páginas; pede uma função e recebe três camadas
de abstração.

Antes de dar a tarefa por concluída, passe este filtro:

- Dá pra fazer isso com menos código? Quase sempre dá.
- Alguma abstração aqui tem um único uso? Então ela não precisa existir.
- Sobrou código morto, import não usado, comentário órfão? Limpe.
- O número de arquivos novos é proporcional ao tamanho do problema?

Uma construção de 1000 linhas frequentemente vira 100 quando alguém pergunta
"não dava pra fazer só assim?". Faça essa pergunta você mesmo, antes.

---

## Fase 3 — Cirurgia em código existente

Quando o pedido é uma modificação pontual num arquivo grande, o agente tende
a alterar o que foi pedido **mais um monte de coisa que ninguém pediu** —
reescreve trechos que não entendeu, remove comentários que achou
desnecessários, "melhora" o que estava funcionando.

Protocolo obrigatório para ajuste pontual:

1. **Delimite o alvo.** Diga em voz alta (ou por escrito) qual bloco, função
   ou seção será tocado — e que o resto do arquivo é intocável.
2. **Conheça o raio de impacto.** Em codebase mapeado com Graphify, consulte
   o que depende do trecho antes de alterá-lo — god node mexido sem querer é
   a origem da maioria dos efeitos colaterais.
3. **Use edição por substituição de trecho**, nunca reescrita do arquivo
   inteiro. Reescrever o arquivo é o que provoca a alteração colateral.
4. **Preserve o que não entendeu.** Código que parece estranho geralmente
   está resolvendo um caso que você não conhece. Na dúvida, mantenha e
   pergunte.
5. **Feche declarando o diff.** Ao terminar, liste o que mudou. Se a lista é
   maior que o pedido, algo saiu do controle — reverta e refaça.

---

## Fase 4 — Auditoria de segurança (9 pontos)

Nunca dê uma aplicação por pronta sem passar por esta lista. Ela cobre as
falhas que mais aparecem em SaaS construído rápido — todas encontradas em
projetos reais, todas exploráveis com o DevTools aberto.

Execute como checklist e reporte cada item como ✅ / ❌ / N/A:

1. **Segredos no bundle** — nenhuma chave secreta pode existir no
   front-end.
2. **Sessão e cookies** — flags corretas, sem dado sensível no client.
3. **Rate limiting** — login, MFA e recuperação de senha protegidos.
4. **CORS** — allowlist explícita, nunca origem curinga.
5. **Vazamento de PII** — a API devolve só o necessário.
6. **JWT / gestão de token** — nunca em query string; invalidação no servidor.
7. **Enumeração de usuários** — mensagens de erro genéricas.
8. **SQL Injection** — ORM ou query parametrizada, jamais concatenação.
9. **Headers e superfície exposta** — endpoints de debug, stack traces, source maps.

**Leia a Parte II para o detalhe de cada item: sintoma, como verificar e
como corrigir.** Não audite de memória — o valor está no detalhe.

Regra de escopo: a auditoria é sempre sobre o próprio sistema do usuário.
Verificar e corrigir a própria aplicação é trabalho defensivo. Não estenda
essas técnicas para sistemas de terceiros.

---

## Formato do relatório de entrega

Ao concluir qualquer tarefa que envolva código de produção, feche assim:

```markdown
## O que mudou
- [arquivo]: [mudança em uma linha]

## Critério de sucesso
- [x] item batido
- [ ] item pendente e por quê

## Auditoria de segurança
[9 itens com ✅ / ❌ / N/A — apenas o que se aplica ao que foi tocado]

## Riscos e pendências
O que ficou de fora e o que pode quebrar.
```

Sem enfeite, sem parabenização, sem resumo do resumo.

---

# Parte II — Auditoria de segurança em detalhe

Falhas recorrentes em SaaS construído com agente. Cada item traz **sintoma**,
**como verificar** e **como corrigir**.

Escopo: esta auditoria se aplica à aplicação do próprio usuário. Verificar o
que você opera é trabalho defensivo padrão.

### Índice

1. [Segredos no bundle do front-end](#1-segredos-no-bundle-do-front-end)
2. [Sessão e cookies](#2-sessão-e-cookies)
3. [Falta de rate limiting](#3-falta-de-rate-limiting)
4. [CORS não configurado](#4-cors-não-configurado)
5. [Vazamento de dados sensíveis (PII)](#5-vazamento-de-dados-sensíveis-pii)
6. [Má gestão de sessão e tokens JWT](#6-má-gestão-de-sessão-e-tokens-jwt)
7. [Enumeração de usuários](#7-enumeração-de-usuários)
8. [SQL Injection](#8-sql-injection)
9. [Superfície exposta e headers](#9-superfície-exposta-e-headers)

---

### 1. Segredos no bundle do front-end

**Sintoma.** Chave de API, secret de serviço ou credencial de banco acessível
por qualquer visitante do site. Acontece porque o agente pediu a chave, o dev
colocou numa variável de ambiente com prefixo público (`VITE_`,
`NEXT_PUBLIC_`, `REACT_APP_`) e o build embutiu isso no JavaScript entregue
ao navegador. A variável de ambiente **não é um cofre** — o prefixo público
significa literalmente "publique isto".

**Como verificar.** Abra o DevTools na aplicação em produção, vá em Sources e
faça uma busca em todos os arquivos por `sk_`, `SECRET`, `API_KEY`, `TOKEN`,
`password`, `Bearer`. Repita no `.map` se os source maps estiverem
publicados. Se qualquer coisa aparecer, o segredo está exposto.

**Como corrigir.**

- Todo segredo fica no servidor. O front-end chama uma rota própria; a rota
  chama o serviço externo com a chave.
- Prefixo público só para valor que pode ir no outdoor: URL da API, ID do
  projeto, chave publicável (`pk_`).
- Se um segredo já vazou, **rotacione a chave**. Remover do código não basta:
  ela já está em cache, em histórico do Git e possivelmente em bundle antigo.
- Adicione `.env` ao `.gitignore` e verifique o histórico com `git log -p`
  antes de assumir que nunca foi commitado.

---

### 2. Sessão e cookies

**Sintoma.** Dados de autenticação guardados no cliente de forma legível ou
manipulável — token no `localStorage`, cookie sem flag, papel do usuário
(`role: "admin"`) armazenado no browser e confiado pelo backend.

**Como verificar.** DevTools → Application → Cookies e Local Storage. Leia o
que está lá. Se você consegue entender e editar, o usuário também consegue.
Teste alterar um valor e recarregar: se a aplicação obedecer ao valor
alterado, o backend está confiando no cliente.

**Como corrigir.**

- Cookie de sessão com `HttpOnly` (JS não lê), `Secure` (só HTTPS),
  `SameSite=Lax` ou `Strict` (barra CSRF básico), `Path` e expiração
  definidos.
- **Autorização se decide no servidor.** O cliente pode dizer quem afirma
  ser; quem confirma é o backend, consultando a fonte de verdade a cada
  requisição sensível.
- Nada de dado sensível no `localStorage` — ele é lido por qualquer script na
  página, o que transforma um XSS em roubo de conta.

---

### 3. Falta de rate limiting

**Sintoma.** Ausência de limite de requisições permite ataque de força bruta
nas rotas de login, MFA e recuperação de senha. Um script testa milhares de
senhas por minuto sem qualquer resistência. O mesmo vale para rotas caras
(envio de e-mail, geração por IA), onde o custo vira o ataque.

**Como verificar.** Dispare a mesma rota de login repetidas vezes com senha
errada. Se a resposta continua idêntica na centésima tentativa, não há
limite.

**Como corrigir.**

- Limite por IP **e** por conta — só por IP não segura, porque o atacante
  rotaciona IP; só por conta permite varredura ampla.
- Bloqueio temporário (lockout) progressivo após N falhas: espera crescente
  a cada nova falha.
- WAF (Web Application Firewall) na frente da aplicação — Cloudflare, AWS
  WAF ou equivalente — para absorver o volume antes de chegar no seu código.
- Rate limit também nas rotas caras, não só nas de autenticação.
- Nas rotas públicas de formulário, some captcha ao limite.

---

### 4. CORS não configurado

**Sintoma.** O servidor aceita requisição de qualquer origem. Configuração
tipo `Access-Control-Allow-Origin: *` — ou, pior, refletir dinamicamente a
origem recebida — combinada com `credentials: true` permite que um site
qualquer faça chamadas autenticadas à sua API usando a sessão da vítima.

**Como verificar.** Inspecione os headers de resposta da API. Se
`Access-Control-Allow-Origin` for `*` ou espelhar o que foi enviado, está
aberto.

**Como corrigir.**

- Allowlist explícita com os domínios de origem confiáveis, e só eles.
- Liste métodos e headers permitidos em vez de liberar tudo.
- `credentials: true` **apenas** com allowlist fechada — nunca junto com
  curinga.
- Ambientes separados: o domínio de staging não entra na allowlist de
  produção.

---

### 5. Vazamento de dados sensíveis (PII)

**Sintoma.** A API devolve mais dados do que o front-end precisa. O caso
clássico é o endpoint que retorna o objeto inteiro do usuário — incluindo
hash de senha, token de reset, CPF, telefone, e-mail de outras pessoas —
porque alguém fez `SELECT *` e serializou direto. A tela mostra só o nome; a
resposta na aba Network mostra o resto.

**Como verificar.** DevTools → Network. Leia o corpo de cada resposta e
compare com o que a interface realmente usa. Qualquer campo a mais é
vazamento.

**Como corrigir.**

- Serializador explícito por endpoint: monte o objeto de resposta campo a
  campo, com allowlist. Nunca devolva o registro cru do banco.
- Hash de senha **nunca sai da camada de autenticação**, nem para o admin.
- Senha sempre com hash forte de senha (bcrypt, scrypt, Argon2), nunca
  MD5/SHA simples. Dado sensível em repouso, criptografado.
- Endpoint de listagem devolve o mínimo; detalhe só sob autorização
  específica.
- Verifique também autorização por objeto: `GET /users/123` precisa checar se
  quem pede tem direito ao registro 123, e não só se está logado.

---

### 6. Má gestão de sessão e tokens JWT

**Sintoma.** Dois erros que costumam andar juntos:

- Token trafegando em parâmetro GET (`?token=eyJ...`). A URL vai para o
  histórico do navegador, para o log do servidor, para o header `Referer` de
  qualquer recurso externo da página e para o print que o usuário manda no
  WhatsApp.
- Logout que só remove o token do `localStorage`. O token continua válido no
  servidor até expirar — quem tiver copiado continua autenticado.

**Como corrigir.**

- Dado de sessão via POST, no header (`Authorization: Bearer ...`) ou em
  cookie `HttpOnly`. Nunca na query string.
- **Invalidação no servidor**: mantenha uma denylist de tokens revogados ou
  um identificador de sessão consultado a cada requisição. Logout precisa
  matar a sessão do lado do servidor, não só apagar do cliente.
- Access token curto (minutos) + refresh token rotativo, com revogação em
  cascata se o refresh for reutilizado.
- Assine com algoritmo fixo e verificado no backend; rejeite `alg: none` e
  qualquer algoritmo não esperado.
- Nunca guarde dado sensível no payload do JWT — ele é apenas assinado, não
  é criptografado. Qualquer um decodifica.

---

### 7. Enumeração de usuários

**Sintoma.** A tela de login diferencia os erros: "e-mail não cadastrado"
para um caso e "senha incorreta" para outro. Com isso o atacante descobre
quais e-mails existem na base, monta uma lista limpa e só então parte para
força bruta ou phishing direcionado. A mesma pista aparece em recuperação de
senha e em cadastro ("e-mail já em uso").

**Como corrigir.**

- Mensagem genérica e idêntica: **"E-mail ou senha inválidos."**
- Vale para todos os fluxos — login, recuperação e cadastro. Na recuperação:
  "Se este e-mail estiver cadastrado, você receberá as instruções."
- Atenção ao canal indireto: se a resposta para e-mail inexistente volta em
  80 ms e a existente em 400 ms, o tempo entrega a informação. Padronize o
  custo da operação nos dois caminhos.
- Códigos de status HTTP também precisam ser iguais nos dois casos.

---

### 8. SQL Injection

**Sintoma.** Query montada por concatenação de string com entrada do
usuário. O risco é a extração do banco inteiro — ou sua destruição. É a falha
mais antiga da lista e continua aparecendo porque o agente, sem instrução em
contrário, escreve a query do jeito mais direto possível.

**Como verificar.** Procure no código por concatenação e interpolação dentro
de queries: `"SELECT ... WHERE id = " + id`, template string com `${}` dentro
de SQL, `f"..."` em Python. Todo resultado é suspeito.

**Como corrigir.**

- **Use um ORM** (Prisma, Drizzle, TypeORM, SQLAlchemy, Eloquent) para
  interagir com o banco em vez de montar SQL na mão. É a correção padrão e
  resolve o caso comum por construção.
- Onde SQL cru for necessário, use **query parametrizada** — os valores vão
  separados do texto da query, nunca colados nele.
- Nome de tabela e de coluna não podem vir do usuário. Se precisar de coluna
  dinâmica, valide contra uma allowlist fixa.
- Usuário do banco com o mínimo de privilégio: a aplicação não precisa de
  `DROP`.
- Mesma lógica vale para NoSQL — objeto vindo do usuário injetado direto num
  filtro do Mongo é injeção também.

---

### 9. Superfície exposta e headers

**Sintoma.** Coisas que ficaram no ar sem intenção: source maps em produção,
rota de debug ou `/admin` sem proteção, stack trace completo na resposta de
erro (entregando caminho de arquivo, versão de framework e estrutura do
banco), console log com dado de usuário, painel de métricas aberto.

**Como corrigir.**

- Desative source maps em produção ou restrinja o acesso a eles.
- Erro em produção retorna mensagem genérica e um ID de correlação; o detalhe
  vai para o log interno.
- Remova rotas de debug e seeds no build de produção.
- Headers mínimos: `Strict-Transport-Security`, `X-Content-Type-Options:
  nosniff`, `X-Frame-Options` (ou `frame-ancestors` via CSP),
  `Content-Security-Policy`, `Referrer-Policy`.
- Dependências atualizadas: rode `npm audit` / `pip-audit` no CI e trate como
  bloqueio de deploy, não como aviso.

---

### Fechamento da auditoria

Reporte cada item como ✅ (verificado e OK), ❌ (falha encontrada, com o
arquivo e a correção proposta) ou N/A (não se aplica ao que foi tocado).

Se houver ❌, ele entra na seção de riscos do relatório de entrega. Não
declare a aplicação pronta com falha aberta sem que isso esteja escrito.


---

# Parte III — Operando agentes de código

Onde o agente erra, onde ele é imbatível, e o que isso muda no papel de quem
conduz. Leia quando a discussão for sobre workflow e produtividade, ou
quando o agente estiver repetidamente errando o alvo.

Base: os quatro problemas observados na prática, somados às observações
públicas de Andrej Karpathy sobre codar com agentes (dez/2025–jan/2026) e à
resposta de Boris Cherny, do time do Claude Code. As ideias abaixo estão
reescritas e resumidas — vale ler as fontes originais.

---

### Os quatro problemas

#### 1. Executa sem contexto

O agente não entende a tarefa, não pede mais contexto, e sai fazendo. Ele
assume o que faltou em vez de perguntar, e segue em frente sem checar se a
suposição estava certa.

Este é o erro de maior custo, porque o resultado **parece** pronto. Não é um
erro de sintaxe que o compilador pega — é um erro conceitual, do tipo que um
dev júnior apressado cometeria: tudo roda, tudo está errado.

**Correção:** spec antes de código (Fase 1 da skill). Ambiguidade se
levanta, não se resolve em silêncio.

#### 2. Complica tudo

Você pede um processo simples e recebe 15 passos. Pede um documento enxuto e
recebe 10 páginas. Pede uma função e recebe três camadas de abstração, mais
código morto do rascunho anterior.

O agente confunde volume com esforço e esforço com qualidade. Uma construção
de 1000 linhas costuma virar 100 assim que alguém pergunta "não dava pra
fazer só assim?".

**Correção:** faça essa pergunta antes de entregar, não depois. Toda
abstração com um único uso é para deletar.

#### 3. Não faz ajustes cirúrgicos

Documento ou arquivo com contexto grande, pedido de modificação pontual — e o
agente altera o que você pediu **mais um milhão de outras coisas**. Reescreve
o que não entendeu, remove comentários que julgou desnecessários, "melhora"
o que funcionava.

Isso acontece principalmente quando ele reescreve o arquivo inteiro em vez de
editar um trecho.

**Correção:** Fase 3 da skill. Alvo delimitado, edição por substituição de
trecho, diff declarado no final.

#### 4. Não tem critério de sucesso

Sem alvo definido, o agente faz trabalho por trabalho: produz, entrega, e não
persegue objetivo nenhum. Ele não sabe quando parou de progredir porque não
sabe onde era pra chegar.

**Correção:** dê critério de sucesso verificável, não instruções. É a
diferença entre "implemente autenticação" e "estes seis testes precisam
passar".

---

### O que o agente faz mal (padrão conhecido)

Vale ter isto explícito porque muda a forma de revisar:

- **Assume no seu lugar.** Preenche a lacuna com um palpite e continua como
  se fosse fato.
- **Não administra a própria confusão.** Não pede esclarecimento, não
  sinaliza inconsistência, não apresenta trade-off, não discorda quando
  deveria — e tende a ser bajulador demais.
- **Infla o código.** Abstração desnecessária, código morto que ele mesmo
  deixou, API mais complexa que o problema.
- **Tem efeito colateral.** Altera comentário e código ortogonais à tarefa,
  especialmente o que não compreendeu bem.

Nada disso se resolve só escrevendo instrução no `CLAUDE.md`. Resolve-se com
processo: spec na entrada, critério na saída, revisão no meio.

---

### O que o agente faz excepcionalmente bem

- **Tenacidade.** Ele não cansa, não desanima e não desiste. Continua
  tentando onde uma pessoa já teria parado para retomar no dia seguinte.
  Resistência deixou de ser gargalo — e isso muda o que vale a pena tentar.
- **Loop com alvo.** É excelente iterando até bater um critério objetivo.
  É exatamente aqui que está o ganho real: não diga o que fazer, dê o
  critério de sucesso e deixe rodar.
- **Expansão, mais que velocidade.** O ganho maior não é fazer o mesmo mais
  rápido; é fazer coisas que antes não compensavam o esforço, e mexer em
  áreas onde faltava repertório.

### Como transformar isso em alavanca

- Teste primeiro, código depois.
- Feche o loop com um verificador automático (build, teste, linter, MCP de
  browser). Um agente com feedback objetivo se corrige sozinho; sem
  feedback, ele adivinha.
- Escreva o ingênuo-e-correto, depois otimize preservando o comportamento.
- Migre do imperativo para o declarativo: descreva o estado final desejado
  em vez da sequência de passos.
- Use plan mode (ou uma etapa de plano explícita) em tarefa não trivial.

---

### O que muda para quem conduz

- **Generalista ganha espaço.** O agente é muito bom no micro — preencher a
  lacuna — e fraco na estratégia macro. Quem define direção e junta
  produto, design e infra rende mais que quem só executa fundo em um
  domínio.
- **A distância entre o dev mediano e o melhor tende a crescer**, porque a
  alavanca multiplica critério. Quem não tem critério multiplica erro.
- **Atrofia é real.** Escrever código e ler código são habilidades
  diferentes, e a de escrever enferruja primeiro. Ler continua funcionando —
  mas só se você continuar lendo. Revise de verdade o que o agente entrega.
- **Times inteiros já operam com a maior parte do código escrita por
  agente.** O gargalo migrou da digitação para o critério, a integração e o
  processo.

A conclusão prática: seu trabalho deixou de ser escrever e passou a ser
**especificar, verificar e podar.**


---

# Parte IV — Ferramentas

Três ferramentas que se encaixam no fluxo da skill. Cada uma resolve uma
etapa diferente: **Graphify** dá contexto ao agente antes de ele começar,
**Spec Driven** organiza a entrada, **LangChain** constrói a inteligência do
produto.

---

### Spec Driven

**O que é.** Desenvolvimento em que a especificação — não o código — é o
artefato central. Você escreve o que o sistema deve fazer e sob quais
critérios estará correto; o agente implementa contra esse documento; a
revisão compara implementação e spec, não implementação e intuição.

**Por que importa aqui.** É a correção direta do Problema 1 (executa sem
contexto). Um agente que recebe spec não precisa adivinhar, e o desvio fica
visível porque existe um documento contra o qual comparar.

**Fluxo em quatro etapas:**

1. **Princípios** — as regras que valem para o projeto inteiro: stack,
   padrões de código, o que nunca pode acontecer. Escreve-se uma vez, vale
   para todas as tarefas.
2. **Spec** — o quê e o porquê de *esta* funcionalidade. Comportamento
   esperado, critérios de aceite, casos de borda, fora de escopo.
   Deliberadamente sem detalhe de implementação.
3. **Plano** — o como. Arquitetura, arquivos afetados, ordem de execução,
   pontos de decisão técnica. Gerado a partir da spec e revisado *antes* de
   virar código.
4. **Tarefas e implementação** — o plano fatiado em unidades pequenas, cada
   uma verificável isoladamente. O agente executa uma por vez.

**Regras que fazem funcionar:**

- Cada critério de aceite precisa ser verificável por quem não escreveu o
  código. "Rápido" não é critério; "resposta abaixo de 300 ms no p95" é.
- A spec inclui explicitamente o que está **fora** de escopo. É isso que
  contém o Problema 2 (complica tudo).
- Mudou o requisito? Atualize a spec primeiro, o código depois. Spec
  desatualizada é pior que spec inexistente, porque dá falsa confiança.
- Spec pequena para tarefa pequena. Um bloco de 15 linhas resolve a maioria
  dos casos — não transforme isso em burocracia.

**Quando não usar.** Correção de typo, ajuste de CSS, tarefa de um arquivo
com resultado óbvio. O custo da cerimônia passa o benefício.

---

### LangChain

**O que é.** Framework de orquestração para aplicações com LLM. Padroniza as
peças que todo produto de IA repete: chamada ao modelo, montagem de prompt,
ligação com ferramentas externas, memória de conversa, busca em base própria
(RAG) e encadeamento de etapas.

**Quando usar.** Quando o produto tem uma feature de IA que não é uma única
chamada de API. Se for uma chamada só, chame o SDK direto — LangChain só
adiciona camada. O ganho aparece quando há várias etapas, várias fontes ou
várias ferramentas.

**As peças que importam:**

- **Chains** — sequência determinística de etapas. Use quando o caminho é
  conhecido de antemão.
- **Agents / LangGraph** — quando o caminho depende do resultado do passo
  anterior. LangGraph modela isso como grafo de estados, com controle
  explícito de ciclo e ponto de parada — mais previsível que um agente
  solto.
- **Tools** — funções do seu sistema expostas ao modelo. Cada tool precisa de
  descrição precisa; descrição vaga é a principal causa de o modelo chamar a
  ferramenta errada.
- **Retrievers / RAG** — busca no seu conteúdo antes de responder. Qualidade
  aqui é ~80% qualidade de chunking e de embedding, não de prompt.
- **Memory** — histórico entre turnos, com política explícita de resumo e
  descarte.
- **LangSmith** — rastreamento e avaliação. Sem observabilidade, uma cadeia
  com falha vira depuração no escuro.

**Cuidados de segurança (obrigatórios, cruzam com a Fase 4):**

- A chave do provedor de LLM fica **no servidor**. Nunca em variável pública
  do front-end — ver item 1 da auditoria.
- Trate saída do modelo como entrada não confiável: valide antes de gravar em
  banco, executar ou renderizar como HTML.
- Tool que escreve ou apaga dado precisa de checagem de autorização própria,
  no seu código. O modelo decide *chamar*; quem decide *permitir* é o
  backend.
- Conteúdo recuperado por RAG pode conter instrução injetada. Ele entra como
  dado, nunca como instrução de sistema.
- Rate limit e teto de custo por usuário nas rotas de IA — são as rotas mais
  caras da aplicação, e por isso as mais atrativas para abuso.

---

### Graphify

**O que é.** Grafo de conhecimento do código, open-source (Apache 2.0) e
rodando localmente. Um comando mapeia o repositório inteiro num grafo que o
assistente **consulta** em vez de sair abrindo arquivo por arquivo.

Cada nó é um símbolo — função, classe, arquivo. Cada aresta é uma relação
real: import, chamada, dependência. E cada aresta carrega a origem da
informação:

- `Extracted` — encontrado no código, com arquivo e linha para abrir.
- `Inferred` — deduzido da estrutura e da nomenclatura. Costuma estar certo,
  mas confira antes de apoiar decisão nele.
- `Ambiguous` — a evidência aponta para mais de um lado, e o grafo diz isso.

Essa marcação é o que separa Graphify de RAG: a resposta é um caminho
auditável, não um score de similaridade.

**Por que entra nesta skill.** É a correção estrutural do Problema 1
(executa sem contexto). O agente que abre 50 arquivos para responder "como
funciona o fluxo de autenticação?" está reconstruindo a arquitetura do zero
a cada sessão e queimando contexto nisso. Com o grafo, ele consulta um
subgrafo pequeno e responde citando o caminho percorrido.

Serve também à Fase 3 (cirurgia): antes de mexer num arquivo, o grafo mostra
o raio de impacto — o que depende daquilo e o que quebra se mudar.

**Instalação.** Pacote no PyPI é `graphifyy`, com dois "y".

```bash
uv tool install graphifyy     # ou: pipx install graphifyy
graphify install              # registra a skill nos assistentes detectados
```

Depois, dentro do assistente:

```
/graphify .
```

Funciona em Claude Code, Cursor, Copilot, Codex, Gemini CLI, Aider e outros
— e o grafo também é servido por MCP, para qualquer cliente MCP.

**O que sai de uma rodada.** Três arquivos locais:

- `graph.html` — grafo interativo. Nó grande é *god node* (o símbolo mais
  conectado: mexeu ali, o impacto se espalha). Cor é comunidade, ou seja,
  módulo detectado automaticamente.
- `GRAPH_REPORT.md` — os god nodes ranqueados, conexões inesperadas entre
  módulos, e os comentários `NOTE`, `WHY` e `HACK` virados em nós ligados ao
  código que explicam. Esse último ponto é o que mais ajuda em projeto
  herdado: o "porquê" fica navegável.
- `graph.json` — o repositório inteiro como entidades e relações. Dá pra
  commitar e compartilhar com o time.

**Consulta.**

```bash
graphify query "quem é dono do faturamento?"
graphify path <a> <b>
graphify explain <nó>
```

**Quando usar.**

- Entrar em codebase que você não conhece, ou retomar projeto parado.
- Antes de refatorar: descobrir o raio de impacto real.
- Onboarding: o grafo responde "quem cuida disso?" melhor que thread de Slack.
- Quando o consumo de contexto estiver alto por causa de leitura de arquivo.

Não vale a pena em projeto pequeno, onde o agente lê tudo sem esforço. O
ganho cresce com o tamanho do repositório.

**Pontos de atenção:**

- O parsing do código é local, sem telemetria — o código em si não sai da
  máquina. Mas arquivos que não são código (docs, PDFs, schemas) podem ser
  lidos pelo modelo que você configurou. Se o repositório tiver documento
  sensível, verifique isso antes, ou aponte para um modelo local.
- `graph.json` commitado expõe a arquitetura inteira do sistema. Em
  repositório privado, tudo bem; pense duas vezes antes em repositório
  público.
- Aresta `Inferred` não é fato. Confirme antes de tomar decisão de
  arquitetura em cima dela — é literalmente para isso que a marcação existe.
- O grafo envelhece junto com o código. Rode de novo depois de mudança
  estrutural, ou configure o hook para manter atualizado.

**Origem.** Nasceu da ideia do Karpathy de uma "wiki legível por LLM" para
codebase — um mapa que o assistente lê em vez de redescobrir a estrutura a
cada sessão. É a mesma linha de raciocínio do
a Parte III deste documento: o gargalo não é a inteligência do modelo,
é o contexto que chega até ele.

