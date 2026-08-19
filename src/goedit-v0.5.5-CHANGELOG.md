# Changelog

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
