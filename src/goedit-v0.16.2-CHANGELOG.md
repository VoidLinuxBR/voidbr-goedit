# Changelog

## v0.16.2

- Corrigido: `Backspace` e `Delete` na seleção em bloco/coluna não
  apagavam o trecho marcado — `Backspace` só desfazia o que tinha
  sido digitado NA MESMA sessão (nada, se nenhuma tecla anterior
  tinha sido digitada), e `Delete` nem era reconhecido, saindo do
  modo bloco sem fazer nada. Agora os dois apagam o trecho marcado em
  todas as linhas de uma vez, direto, sem precisar digitar nada antes.

## v0.16.1

- Corrigido bug real, achado com diagnóstico direto no terminal do
  usuário: em alguns terminais/gerenciadores de janela, `Shift+seta`
  sozinho chega ao goedit com o bit de Shift "perdido" — só o de Ctrl
  presente — enquanto `Ctrl+Shift+seta` junto chega correto (com os
  dois bits). Isso fazia `Shift+↑`/`↓`/`←`/`→` não selecionar nada de
  verdade nesses ambientes. Agora, como `Ctrl+seta` sozinho não é
  usado pra nada no editor, ele é tratado como equivalente a
  `Shift+seta` — mas só pras 4 setas, nunca `Home`/`End`, pra não
  atropelar `Ctrl+Home`/`Ctrl+End` (que usam exatamente o mesmo sinal
  nesses terminais, só que pra outra função). Ferramenta de
  diagnóstico usada pra achar isso não faz parte do projeto — foi só
  pra investigação pontual.

## v0.16.0

- `Shift+↑`/`Shift+↓` agora marcam **linhas inteiras**, não seguem mais
  a coluna do cursor (igual VS Code) — o primeiro toque marca a linha
  atual completa (não importa em qual coluna o cursor estava), toques
  seguintes vão adicionando uma linha inteira a mais de cada vez.
  `Shift+←`/`Shift+→` continuam com seleção normal por caractere.

## v0.15.3

- Corrigido: `Shift+Alt+↑`/`Shift+Alt+↓` estavam invertidos (duplicando
  na direção contrária à tecla apertada), reportado em teste real no
  xfce4-terminal — não reproduzi no sandbox (a codificação exata da
  combinação Shift+Alt+seta parece variar por terminal), mas troquei
  as duas direções pra bater com o comportamento observado de verdade.

## v0.15.2

- `Shift+Alt+↑`/`↓` agora duplicam o **bloco inteiro** quando há uma
  seleção multi-linha ativa (não só a linha do cursor) — a seleção
  passa a marcar a cópia nova, igual o VS Code. Sem seleção, continua
  duplicando só a linha atual como antes.

## v0.15.1

- `Shift+Alt+↑` / `Shift+Alt+↓` duplicam a linha atual pra cima/baixo
  (mesmo atalho do VS Code) — diferente do `Ctrl+D`, que sempre
  duplica pra baixo, e do `Alt+↑`/`Alt+↓` puro, que continua só
  movendo a linha (não duplicando)

## v0.15.0

- **Seleção em bloco/coluna** (`internal/ui/blockselect.go`), igual o
  VS Code: `Ctrl+Shift+↑`/`Ctrl+Shift+↓` marca a mesma faixa de colunas
  em várias linhas de uma vez (desenha um retângulo, não segue o
  texto como a seleção normal), `Ctrl+Shift+←`/`Ctrl+Shift+→` ajusta
  a largura da faixa. Digitar troca aquele pedaço em **todas as
  linhas marcadas ao mesmo tempo**, como uma única alteração de undo.
  `Enter` confirma, `Esc` cancela e restaura o texto original.
  Funciona tanto pra substituir texto (marca 2+ colunas de largura)
  quanto só inserir em várias linhas ao mesmo tempo (largura zero —
  útil pra comentar/prefixar várias linhas de uma vez).

## v0.14.0

- Formatador: agora tenta pelo shebang quando o arquivo não tem
  extensão (mesma lógica do syntax highlighting), e cai no `shfmt`
  como padrão universal se nem isso achar nada
- Formatador: adicionado `.yml`/`.yaml` via `prettier`
- Menu de contexto: corrigido desalinhamento causado por rótulos com
  acento (a largura era calculada em bytes, não em colunas visuais —
  "Formatar código" tinha o "ó" contando 2 bytes mas só 1 coluna,
  desalinhando os outros itens)
- Menu de contexto: ganhou uma moldura de verdade (┌─┐│└─┘) ao redor
  dos itens
- Menu de contexto: cores trocadas pro tema Tokyo Night (fundo
  azul-marinho escuro, texto lavanda claro) em vez do branco com
  preto de antes

## v0.13.0

- **Formatador de código externo**: `Shift+Alt+F` (mesmo atalho do VS
  Code) ou "Formatar código" no menu de contexto do texto roda o
  formatador certo pra linguagem do arquivo, como uma única alteração
  de undo. Vem com `gofmt` (.go) e `shfmt` (.sh/.bash) configurados;
  fácil de estender pra mais linguagens (`internal/ui/format.go`).
  Se o binário do formatador não estiver instalado, ou o tipo de
  arquivo não tiver formatador configurado, mostra mensagem clara na
  barra de status em vez de travar ou falhar silenciosamente.

## v0.12.0

- Menu de contexto (clique direito) agora também no **texto principal**:
  Copiar / Cortar / Colar / Selecionar tudo. Clicar dentro de uma
  seleção já existente preserva ela (útil pra copiar/cortar); clicar
  fora move o cursor pro ponto do clique, igual um clique esquerdo
  normal faria.

## v0.11.1

- **Corrigido bug crítico de UTF-8** que corrompia caracteres
  acentuados e emoji em três lugares: digitar diretamente
  (`InsertRune`), colar (`InsertTextAtCursor`) e apagar com Backspace.
  A causa: o cursor avançava/recuava sempre **1 posição por
  caractere**, mas em UTF-8 um caractere acentuado ocupa 2 bytes e um
  emoji até 4 — isso cortava os caracteres ao meio, corrompendo tudo
  que vinha depois na linha. Reportado como "resíduo binário" ao
  colar texto selecionado com o mouse (o texto real tinha acentos em
  português; testes anteriores com teclado usavam só ASCII, por isso
  não aparecia). Testado digitando frases inteiras com acentos,
  apagando com Backspace, e copiando/colando texto com emoji — tudo
  intacto agora, confirmado byte a byte.

## v0.11.0

- **Autocompletar por palavras do buffer** (`internal/ui/suggest.go`):
  digitar 2+ letras de um identificador mostra um popup com palavras já
  usadas no arquivo que começam com isso. `↓`/`↑` navega, `Tab`/`Enter`
  aceita (substitui o trecho digitado pela palavra inteira, como uma
  única alteração de undo), `Esc` cancela, continuar digitando refina a
  busca. **Não é IntelliSense semântico** (não entende tipos, escopo,
  nem é ciente da linguagem) — é busca textual no que já foi escrito,
  parecido com o keyword completion nativo do Vim.
- **`x` de fechar em cada aba do editor** (voltei atrás da decisão da
  v0.10.0 a pedido — combina bem com quem trabalha com poucas abas
  abertas por vez)
- Menu de contexto mais compacto (margem reduzida) — não é possível
  mudar o tamanho da fonte de um elemento específico de dentro do
  programa (isso é controlado pelo terminal, não pelo goedit), mas
  dava pra deixar o menu menos "inchado" visualmente
- Arquivos com extensão desconhecida (não só sem extensão nenhuma)
  agora também caem no highlight de bash como padrão, ao invés de
  ficarem sem nenhum destaque de sintaxe

## v0.10.0

- **Menu de contexto (botão direito do mouse)**: clique direito numa
  aba do editor abre um menu com Fechar / Fechar outras / Fechar
  todas / Salvar; clique direito no título da sidebar abre Fechar /
  Atualizar. Clicar num item executa a ação; clicar fora só fecha o
  menu, sem fazer nada.
- **Sidebar redimensionável**: arrasta a divisória (│) entre a
  sidebar e o texto com o botão esquerdo do mouse pra mudar a largura
- Sidebar: `x` clicável no canto direito do título, fecha ela (mesma
  ação do `Ctrl+B`)
- Decisão consciente: não implementei um "x" fixo em cada aba
  individual — com o menu de contexto cobrindo o fechamento, um x por
  aba ocuparia espaço extra sempre, ficando apertado com várias abas
  numa tela estreita. Dá pra reconsiderar se fizer falta no uso real.

## v0.9.0

- Sidebar: título "SIDEBAR" agora usa a mesma cor da aba ativa (fundo
  azul-aço), em vez do texto cinza sem destaque de antes
- Sidebar: busca incremental por digitação (type-ahead), estilo
  explorador de arquivos clássico — digitar `f` pula pro primeiro
  item que começa com "f"; digitar `r` logo em seguida refina pra
  "fr"; parar de digitar por um instante reinicia a busca do zero na
  próxima tecla. Mostra o que está sendo buscado na barra inferior.

## v0.8.2

- Revertido: clicar num arquivo não fecha mais a sidebar automaticamente
  (mudança da v0.8.0). Agora abre o arquivo numa aba normalmente e
  mantém a sidebar aberta — só fecha de verdade com `Ctrl+B`
- `internal/ui/mouse.go` reorganizado: helpers compartilhados
  (`pointInSidebar`, `clamp`) eliminam duplicação entre clique e
  rolagem, seções com cabeçalho, nomes mais consistentes
  (`scrollPaneAt` em vez de `scrollAt`)
- Sidebar: título trocado de "ARQUIVOS" pra "SIDEBAR"

## v0.8.1

- `goedit arquivo1 arquivo2 arquivo3` (ou `goedit *.sh` — o shell expande
  o glob antes de chegar no programa) agora abre **todos** os arquivos
  passados como abas separadas, com o primeiro ficando ativo. Antes só
  o primeiro argumento era usado, o resto era ignorado silenciosamente.
- Corrigido crash real introduzido nessa mesma mudança: abrir o editor
  **sem nenhum argumento** quebrava com "slice bounds out of range" —
  pego e corrigido antes de publicar.

## v0.8.0

- Sidebar: atalhos globais de app (`Ctrl+Q`, `Ctrl+S`, `Ctrl+O`,
  `Ctrl+N`, `Ctrl+W`, `Ctrl+\`, `Ctrl+L`, `Ctrl+F`, `Ctrl+H`, `Ctrl+G`,
  `Ctrl+P`, `Alt+←/→`) agora funcionam mesmo com o foco na lista de
  arquivos — antes só as teclas de navegação respondiam ali
- Barra de status: cores bem mais vívidas e variadas — amarelo pro
  modo `INSERT` (vermelho pro `OVERWRITE`), azul marinho no meio,
  turquesa no bloco de encoding, fúcsia no bloco de posição
- Sidebar: **clicar num arquivo agora fecha a sidebar por completo**
  (igual apertar `Ctrl+B` de novo) — diferente do `Enter` pelo
  teclado, que mantém ela aberta (só sem foco) pra continuar navegando
- Rolagem do mouse agora funciona dentro da sidebar também, rolando a
  lista de arquivos quando o ponteiro está em cima dela

## v0.7.1

- Barra de status: cor de destaque unificada num azul mais vívido
  (modo/encoding/posição), mais próxima da referência visual pedida
- Sidebar abre automaticamente ao iniciar o editor **sem** passar um
  arquivo por parâmetro (já focada, pronta pra navegar); continua
  fechada quando um arquivo é passado, como já era
- Corrigido: a barra de seleção da sidebar sumia completamente ao
  abrir um arquivo (perdia o foco). Agora continua visível, só num
  tom mais discreto quando sem foco — sempre dá pra ver qual arquivo
  está selecionado/aberto

## v0.7.0

- Barra de status reformulada, estilo airline/lightline: blocos
  coloridos (modo INSERT/OVERWRITE muda de cor, encoding, posição) e
  informações novas — tipo de arquivo detectado, contagem de palavras
  e porcentagem de progresso no arquivo, além do nome/linha/coluna
  que já existiam

## v0.6.4

- Sidebar: adicionada entrada `../` no topo da lista (quando não está
  na raiz) — dá um jeito óbvio e clicável de voltar pra pasta anterior
  (antes só dava pra voltar com Backspace, pouco descobrível)
- Sidebar: `Home`/`End` agora pulam pro primeiro/último item da lista
- Corrigido bug real: clicar num arquivo da sidebar com a lista rolada
  (scroll ativo) abria o item errado — o clique não considerava o
  quanto a lista tinha rolado. Agora sempre abre o item certo, o que
  realmente está sob o cursor do mouse.

## v0.6.3

- Sidebar: `Page Down` / `Page Up` agora funcionam, movendo a seleção
  uma página por vez (calculado com a altura real do terminal),
  travando certinho no início/fim da lista sem estourar

## v0.6.2

- Corrigido bug real na sidebar: ela nunca teve rolagem — sempre
  desenhava a partir do primeiro arquivo, então ao navegar além do que
  cabia na tela a seleção saía da área visível e sumia (o destaque só
  reaparecia voltando pra cima, de volta pros itens do topo). Agora a
  lista rola de verdade acompanhando a seleção, igual o texto principal.

## v0.6.1

- Corrigido: `←`/`→`/`Home`/`End` não funcionavam durante o F2 depois
  da reestruturação pro modo inline (só sincronizavam a posição do
  cursor no texto ao digitar, não ao navegar)
- F2: `=` e aspas (`"`/`'`) agora também cortam a palavra, junto com
  espaço. Em `variavel = "teste"`, marcar em cima de `variavel` pega
  só ela, e marcar dentro da string pega só `teste` (sem as aspas)

## v0.6.0

- F2 reestruturado pra ser de verdade **inline**: o cursor agora fica
  no próprio texto principal, na ocorrência onde você apertou F2 —
  não pula mais pra uma linha/campo separado embaixo. A linha de baixo
  virou só um rótulo informativo (palavra, quantas ocorrências, nome
  novo em tempo real), sem cursor nela. Resolve de vez qualquer
  confusão sobre "onde" o cursor deveria estar durante o rename, e
  evita todos os casos de canto de tela / linha reservada que só esse
  campo separado sofria.

## v0.5.6

- F2: força cursor em bloco sólido (não piscante, não fino) durante o
  modo de renomear — se o cursor "sumia" por causa de um estilo padrão
  do terminal difícil de enxergar em cima do fundo destacado, isso
  resolve. Volta ao estilo normal do terminal fora do modo de renomear.

## v0.5.5

- Corrigido bug real no F2 (reportado no xfce4-terminal, baseado em
  VTE): o cursor podia cair exatamente no canto inferior direito da
  tela (última linha, última coluna) — um caso clássico de
  comportamento inconsistente entre terminais. Só o campo do F2 usa a
  última linha da tela; a edição normal do texto nunca chega lá. Agora
  reservamos 1 coluna de margem à direita, então o cursor nunca mais
  alcança esse canto, em nenhum tamanho de terminal.

## v0.5.4

- Scroll do mouse: o cursor agora fica na linha onde o ponteiro do
  mouse está (coluna 1, início da linha), acompanhando o scroll —
  antes ele só se movia relativo à posição anterior, o que fazia ele
  "fugir" pras extremidades da tela em vez de ficar sob o mouse

## v0.5.3

- Corrigido bug real no F2: o cursor sumia e ficava escondido pra
  sempre ao editar nomes um pouco mais longos. Causa: o rótulo
  ("Renomear 'nome' (N ocorrência(s)) para: ") mais o próprio nome
  sendo editado facilmente passavam da largura do terminal (bastava
  um identificador de uns 25-30 caracteres, sem nem precisar digitar
  nada extra), e o cursor calculava uma posição fora da tela — o tcell
  esconde o cursor nesse caso e não tinha como ele voltar sozinho.
  Agora o campo rola horizontalmente (igual o texto principal já
  fazia) pra manter o cursor sempre visível.

## v0.5.2

- Removido o `Clear()` de tela inteira que rodava em TODO frame — o
  tcell já faz diff de célula por célula sozinho, então isso só
  forçava redesenho total sem necessidade a cada tecla/clique/scroll,
  o que sobrecarrega terminais reais numa rajada de eventos rápidos
  (ex: scroll do mouse) e pode causar artefatos visuais como o cursor
  sumindo. Cada área da tela agora se preenche por completo sozinha
  (sem depender do Clear global), então não fica sobra de conteúdo
  velho — testado trocando entre linhas longas/curtas e arquivos
  diferentes.

## v0.5.1

- Corrigido bug real no F2: o cursor visível do terminal nunca seguia
  a navegação dentro do campo de renomear (Left/Right/marcação) — ficava
  preso na posição de antes de entrar no modo, só se movia quando você
  digitava algo. Agora o cursor acompanha `←`/`→`/`Home`/`End` e a
  marcação com `Shift` em tempo real.

## v0.5.0

- F2: mudou o critério de "palavra" — agora só corta em espaço em
  branco. Qualquer outra coisa colada (hífen, ponto, parênteses,
  vírgula, barra) conta como parte do mesmo token. Bom pra nomes de
  comando/pacote (`void-install`) e caminhos (`/usr/bin/env`); em
  código, também engole pontuação colada sem espaço (`print(x)` vira
  um token só se não tiver espaço dentro)

## v0.4.1

- F2: nomes com hífen (tipo `void-install`, `meu-pacote`) agora são
  tratados como uma palavra só — antes o hífen cortava em duas, e F2
  só pegava metade do nome

## v0.4.0

- F2: o campo de renomear agora suporta marcar um trecho do nome com
  `Shift+←/→/Home/End` — digitar por cima do trecho marcado substitui
  só ele, localmente (como um campo de texto normal). Sem marcação,
  continua exatamente como antes (insere/sobrescreve na posição do
  cursor)

## v0.3.3

- F2: o cursor do campo de renomear agora começa na mesma posição
  RELATIVA que estava dentro da palavra (início, meio ou fim) — antes
  sempre pulava pro fim
- F2: confirmado/documentado que uma seleção ativa nunca muda qual
  palavra é renomeada — o alvo é sempre a palavra sob o cursor, igual
  o VS Code faz com o LSP (Rename Symbol opera no símbolo do cursor,
  não no texto selecionado)

## v0.3.2

- F2: removido o comportamento de "primeira tecla limpa tudo". Agora o
  campo de renomear tem cursor de verdade (começa no fim do nome
  original) e responde ao modo Insert/Overwrite do editor — digitar
  insere normalmente (ou sobrescreve, se o modo overwrite estiver
  ligado), igual à edição normal de texto. `←`/`→`/`Home`/`End` navegam
  dentro do nome, `Insert` alterna o modo.

## v0.3.1

- Corrigido: ao apertar F2, a palavra sumia/cortava na hora (o preview
  começava com o nome vazio). Agora a palavra fica intacta e destacada
  até você começar a digitar — a 1ª tecla substitui o nome inteiro (como
  um texto pré-selecionado), o resto acrescenta normalmente.

## v0.3.0

- `F2` agora é renomear AO VIVO: destaca todas as ocorrências da palavra
  no texto e vai atualizando o conteúdo em tempo real conforme você
  digita o novo nome, como o Rename Symbol do VS Code. `Enter` confirma
  (undo desfaz tudo num passo só), `Esc` cancela e restaura o original

## v0.2.0

- Suporte a mouse: clique posiciona cursor, clique+arrasto seleciona,
  clique em aba troca de buffer, clique na sidebar abre arquivo/pasta,
  roda do mouse rola o texto
- Flag `--version` / `-v`

## v0.1.0

Primeira versão "fechada" do goedit — editor de texto de terminal em Go,
com abas, split, sidebar, syntax highlighting, plugins em Lua e atalhos
no estilo VS Code.

### Recursos
- Abas (múltiplos buffers), split de painel, sidebar de arquivos
- Syntax highlighting via chroma, com cache (detecção de linguagem não
  recalcula a cada tecla)
- Detecção de linguagem por shebang para arquivos sem extensão, com
  bash como padrão final
- Busca, buscar/substituir, ir para linha
- Seleção de texto (Shift+setas), copiar/recortar/colar, selecionar tudo
- Indentar/dedentar bloco selecionado (Tab / Shift+Tab), respeitando
  `~/.config/goedit/settings.json` (tabWidth, insertSpaces)
- Duplicar linha, mover linha (Alt+↑/↓), comentar/descomentar linha
- Modo overwrite (tecla Insert) e tecla Delete
- Renomear todas as ocorrências de uma palavra no arquivo (F2)
- Undo/redo com agrupamento de digitação contínua num passo só
- Sistema de plugins em Lua (`~/.config/goedit/plugins/*.lua`), com
  comandos rodáveis pela paleta (Ctrl+P)
- Flag `--version` / `-v`

### Correções ao longo do desenvolvimento
- Performance: cache de detecção de linguagem e de highlight por linha
  (redraw de tela cheia foi de ~146ms para ~0,003ms)
- Performance: undo deixou de copiar o buffer inteiro a cada tecla
  (agrupamento por sequência contínua de digitação)
- Cursor visual desalinhado em 1 linha (esquecia a linha de abas)
- Tabulação não respeitava tab-stops na tela
- Tab com texto selecionado apagava em vez de indentar
- Tecla Delete não fazia nada
- Tecla Insert não alternava modo overwrite
- Ctrl+F pulava a ocorrência já na posição do cursor na primeira busca
- Sidebar agora começa desligada (Ctrl+B liga)
