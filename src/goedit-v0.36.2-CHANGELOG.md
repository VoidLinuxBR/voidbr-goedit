# Changelog

## v0.36.2

- **Clique duplo agora avisa quando a sincronização com o clipboard do
  sistema falha** (`copiado (só local, sistema indisponível): <palavra>`),
  em vez de fingir sucesso silenciosamente. `sysclip.Copy` passou a
  devolver se conseguiu de verdade, não só tentar sem informar nada.
  Testado simulando falha intermitente real (ferramenta de clipboard
  falsa que falha em chamadas alternadas): as duas mensagens (sucesso
  e falha) aparecem corretamente, cada uma na hora certa. Falhas da
  ferramenta externa em si (`wl-copy`/`xclip`/`xsel`) continuam sendo
  limitação do ambiente/sessão gráfica, fora do controle do goedit —
  agora pelo menos ficam visíveis em vez de silenciosas. O clipboard
  interno do goedit (colar com `Ctrl+V` dentro do editor) nunca falha,
  independente disso.

## v0.36.1

- **Corrigido: clique duplo falhava com frequência ao marcar a
  palavra.** Causa: exigia que os dois cliques caíssem na posição de
  tela exata (mesma coluna/linha) — mãos reais não ficam
  perfeitamente paradas entre dois cliques rápidos, então um clique 1
  coluna diferente do outro já falhava. Agora verifica se os dois
  cliques caem dentro dos limites da **mesma palavra**, bem mais
  tolerante. Testado com cliques em colunas bem diferentes (10 e 15)
  dentro da mesma palavra de 12 letras. Confirmado que arrasto normal
  de seleção continua funcionando sem disparar clique duplo à toa,
  mesmo movendo dentro da mesma palavra sem soltar o botão.

## v0.36.0

- **Clique duplo do mouse seleciona a palavra e copia pro clipboard**
  automaticamente — igual outros editores. Detecta 2 cliques na mesma
  posição de tela dentro de 400ms (sem contar movimentos de arrasto
  contínuo como clique novo). Testado via protocolo SGR do mouse:
  seleciona a palavra sob o cursor, mostra `copiado: <palavra>`, e
  confirma que dá pra colar com `Ctrl+V` depois. Clique simples e
  arrasto normal de seleção continuam funcionando sem mudança.

## v0.35.1

- **Resultado da busca (`Ctrl+F`/`Ctrl+W`) agora centraliza a linha na
  tela**, dando contexto acima e abaixo — antes só rolava o mínimo
  necessário, deixando o resultado colado bem na borda de cima ou de
  baixo, sem contexto nenhum. Igual `nano`/`vim` fazem. Testado com
  arquivo de 100 linhas (resultado ficou na posição 12 de 22 visíveis
  — praticamente centralizado) e com arquivo pequeno (não rola à toa
  quando tudo já cabe na tela).

## v0.35.0

- **Busca (`Ctrl+F`/`Ctrl+W`) agora ignora maiúsculas/minúsculas** —
  buscar `termo` encontra `Termo`, `TERMO`, `termo`, etc. Testado:
  buscar em minúsculo encontrando termo em maiúsculo no arquivo,
  posição do cursor conferida exatamente.
- **`Substituir` (`Ctrl+H`) continua sensível a maiúsculas/minúsculas**
  de propósito, sem mudança — testado explicitamente: buscar `termo`
  só afeta o `termo` minúsculo, deixando `Termo` e `TERMO` intocados
  no mesmo arquivo.

## Pendências conhecidas (não implementadas, decisão deliberada)

- **Rolagem (setas/PgUp/PgDn) redesenha o painel inteiro a cada
  tecla**, em vez de usar rolagem nativa do terminal (scroll region) —
  medido: ~4.300 bytes enviados por tecla, contra uns 100-500 bytes
  que um `nano`/`ncurses` bem otimizado mandaria pra rolar 1 linha.
  Não afeta o tempo de processamento do `goedit` em si (medido em
  microssegundos), mas sobrecarrega o terminal de verdade
  (compor/renderizar tudo de novo), o que pode ser percebido como
  lentidão ao rolar rápido. Corrigir de verdade exigiria implementar
  rolagem nativa manualmente (a lib `tcell` não tem isso pronto) —
  avaliado e decidido não investir nisso por enquanto (custo alto pro
  ganho).

## v0.34.0

- **`Ctrl+Q` unificado em todos os perfis de teclado** — antes só o
  `nano-hibrido` tinha o comportamento de "fechar aba atual, sair se
  for a última"; `vscode`/`nano` saíam do programa direto. Agora os 3
  perfis funcionam igual:
  - Mais de uma aba aberta: fecha só a atual, sem perguntar nada, as
    outras continuam
  - Última aba, sem alteração: sai direto
  - Última aba, com alteração: menu `Sair sem salvar` / `Sair e
    salvar` (nomes/ordem ajustados a pedido — antes era "Salvar e
    fechar"/"Fechar sem salvar")
  Testado nos 3 perfis e com múltiplas abas.

## v0.33.3

- **Corrigido: cursor "subia" uma linha ao cortar a última linha do
  arquivo com `Ctrl+K`** (perfis `nano`/`nano-hibrido`) — mesmo já
  não apagando mais nada acima (v0.33.2), o cursor ainda recuava
  visualmente. Agora, ao cortar o que é a última linha, ela só é
  **limpa no lugar** (não removida do array) — o cursor fica
  exatamente onde estava. Testado segurando `Ctrl+K` 6 vezes seguidas
  na última linha: posição do cursor continua `Ln 4` em todas,
  nenhuma vez recua. Efeito colateral conhecido e aceito: colar de
  volta bem em cima dessa linha limpa deixa uma linha em branco extra
  sobrando — não corrigido a pedido, já que o essencial (cursor fixo)
  era a prioridade.

## v0.33.2

- **Corrigido bug real no `Ctrl+K` (perfis `nano`/`nano-hibrido`):
  segurar a tecla a partir da última linha do arquivo "subia"
  apagando linhas acima do ponto de partida.** Causa: ao apagar a
  última linha, não sobra nada embaixo pra ocupar a posição do
  cursor, então ele recuava pra linha anterior — e o próximo Ctrl+K
  (ainda segurado) acabava pegando essa linha "de cima" também.
  Agora a sequência de corte para ao chegar no fim do arquivo; um
  Ctrl+K a mais nesse ponto não faz nada. Testado exatamente no
  cenário reportado: arquivo de 4 linhas, cursor na última, segurando
  Ctrl+K 5 vezes seguidas — só a linha 4 foi cortada, as 3 de cima
  sobreviveram intactas. Testado nos dois perfis; corte no meio do
  arquivo confirmado sem regressão.

## v0.33.1

- **Corrigido: `Ctrl+K` (perfis `nano` e `nano-hibrido`) confirmado
  no comportamento certo** — sempre apaga a linha inteira (não parcial
  pelo cursor, uma tentativa anterior errada foi revertida), segurando
  apaga linha por linha pra baixo a partir de onde o cursor estava, e
  **nunca afeta linhas acima** de onde o cursor começou. Testado
  explicitamente: 2 linhas antes do cursor + segurar `Ctrl+K` 3x a
  partir do meio → as linhas de cima ficaram intocadas, `Ctrl+U`
  restaura tudo de uma vez, voltando exatamente ao arquivo original.

## v0.33.0

- **Paleta de comandos navegável (`Ctrl+P`)** — antes era só um campo
  de texto puro, exigindo lembrar e digitar o nome exato do comando
  do plugin. Agora abre mostrando a lista completa, com:
  - Filtro por digitação em tempo real
  - `↑`/`↓` navegam entre os itens
  - `Enter` roda o comando destacado
  - `Esc` cancela sem executar nada
  - Rolagem automática se a lista passar de 12 itens visíveis
  - Mensagem `(nenhum comando encontrado)` quando o filtro não bate
    com nada
  Visual reaproveita o mesmo estilo (Tokyo Night, bordas com linhas)
  do menu de contexto que já existia. Testado de ponta a ponta com
  múltiplos plugins reais.

## v0.32.0

- **`Ctrl+K`/`Ctrl+U` respeitam bloco/texto selecionado**, nos dois
  perfis nano (`nano` e `nano-hibrido`): com uma seleção marcada
  (`Shift+setas`, `Ctrl+^`, etc), `Ctrl+K` agora corta o **bloco
  inteiro selecionado** em vez da linha inteira, e `Ctrl+U` restaura
  esse bloco. Sem seleção nenhuma, continua no comportamento de linha
  de sempre (acumulando em sequência). Testado nos dois perfis com
  resultado idêntico e matematicamente conferido (posição exata do
  corte/colagem).

## v0.31.2

- **Corrigido: `Ctrl+U` no perfil `nano-hibrido` (o padrão) continuava
  sendo "desfazer"**, mesmo depois do `Ctrl+K` passar a acumular
  cortes em sequência (v0.31.1) — resultado: colar depois de cortar
  várias linhas só restaurava uma de cada vez (desfazendo um corte
  por `Ctrl+U`), não o bloco inteiro de uma vez. Agora `Ctrl+U` também
  virou "colar" nos dois perfis nano (`nano` e `nano-hibrido`),
  formando um par consistente com o `Ctrl+K` — testado com 4 cortes
  seguidos + 1 `Ctrl+U` só, voltando exatamente ao arquivo original
  nos dois perfis. `Ctrl+Z` (desfazer de verdade) continua funcionando
  normalmente nos dois, sem mudança.

## v0.31.1

- **Corrigido: `Ctrl+K` (perfis `nano` e `nano-hibrido`) não acumulava
  cortes em sequência** — cada `Ctrl+K` estava substituindo o
  clipboard em vez de somar, então cortar várias linhas seguidas e
  colar só trazia a última, perdendo as anteriores de vez. Agora
  segue o comportamento real do `nano`: `Ctrl+K` repetido sem
  nenhuma outra tecla no meio acrescenta cada linha cortada ao
  clipboard, formando um bloco só, restaurável de uma vez. Testado
  nos dois perfis: `nano` clássico (`Ctrl+U` cola) e `nano-hibrido`
  (`Ctrl+V` cola, já que esse perfil não mexe no `Ctrl+U` — que
  continua sendo desfazer puro ali, confirmado à parte).
- Confirmado que colar (`Ctrl+U`/`Ctrl+V`) várias vezes seguidas
  sem cortar de novo repete o mesmo conteúdo a cada vez, como já
  era esperado.

## v0.31.0

- **Histórico de busca**, persistido em
  `~/.config/goedit/search_history.json` (mesmo estilo de
  `positions.json`) — mantém entre sessões, não só na execução atual.
  No prompt de busca (`Ctrl+F` em vscode/nano-híbrido, `Ctrl+W` em
  nano), `↑`/`↓` navegam pelos termos buscados antes, do mais recente
  pro mais antigo e voltam; confirmar (`Enter`) busca de novo com o
  termo escolhido. Não duplica buscas repetidas consecutivas. Outros
  prompts (Salvar como, Abrir arquivo, etc) não são afetados — a
  navegação por histórico só vale no prompt de busca mesmo. Testado
  de ponta a ponta: histórico sobrevive a fechar e reabrir o processo
  de verdade, e reutilizar um termo do histórico encontra e destaca a
  ocorrência certa.

## v0.30.1

- **Todos os perfis de teclado aparecem na barra de status agora**,
  inclusive `vscode` (antes só `nano`/`nano-hibrido` apareciam;
  `vscode` ficava "escondido" por ser o padrão antigo)
- **Padrão sem `settings.json` mudou pra `nano-hibrido`** (era
  `vscode`) — testado do zero, sem nenhum arquivo de config, já
  inicia mostrando `nano-hibrido`
- `F9` continua salvando a escolha no `settings.json` normalmente
  (reconfirmado depois das mudanças acima)

## v0.30.0

- **Perfis de teclado configuráveis** — novo parâmetro `"keymap"` no
  `settings.json`:
  - `"vscode"` (padrão) — o que já existia, sem mudança
  - `"nano"` — teclas clássicas do `nano` de verdade: `Ctrl+O` salva,
    `Ctrl+X` sai, `Ctrl+K`/`Ctrl+U` corta/cola, `Ctrl+W` busca,
    `Ctrl+A`/`Ctrl+E` início/fim de linha, `Ctrl+Y`/`Ctrl+V` página
    anterior/seguinte, `Ctrl+D` apaga caractere, `Ctrl+H` backspace,
    `Ctrl+_` ir pra linha, `Ctrl+^`/`Ctrl+6` marcar seleção, `Ctrl+C`
    mostra posição do cursor, `Ctrl+G` ajuda, `Ctrl+R` lê outro
    arquivo no cursor, `Ctrl+\` substituir. Testado tecla por tecla.
  - `"nano-hibrido"` — igual `vscode` em tudo, exceto `Ctrl+W` (vira
    buscar) e `Ctrl+Q` (assume o antigo papel do `Ctrl+W`: fechar
    aba, ou sair se for a última)
- **`F9` alterna entre os três perfis em tempo real**, sem precisar
  reabrir o editor — testado mudando de `vscode` pra `nano` e
  confirmando que `Ctrl+A` já mudou de comportamento na mesma sessão.
  Salva a escolha automaticamente no `settings.json`.
- **Perfil ativo aparece na barra de status** quando não é o padrão
  (`vscode` fica "escondido" pra não poluir à toa no caso mais comum)
- Vim e Emacs ficam de fora por enquanto — combinado deixar pra uma
  próxima rodada, dado o tamanho da tarefa (modo modal do vim
  especialmente precisa de uma máquina de estados nova inteira que o
  goedit não tem hoje).

## v0.29.1

- **Corrigido: `Page Down`/`Page Up` não rolavam a tela de verdade.**
  Causa: moviam o cursor por um número fixo de 20 linhas, sem tocar
  na rolagem — numa área visível maior que isso (comum, ~22-23
  linhas em terminais típicos), o cursor nunca chegava a sair da
  tela, então a rolagem nunca disparava. Agora usa a altura real da
  área de texto e move cursor e rolagem juntos, mantendo a posição
  relativa do cursor na tela — igual `nano`/`less`. Testado com
  arquivo de 100 linhas: `PgDn` pula corretamente de página em
  página (linha 1 → 23 → 45), `PgUp` volta exatamente, e não passa
  do fim do conteúdo real quando repetido até o fim do arquivo.

## v0.29.0

- **Colar (paste nativo do terminal) muito mais rápido — igual o
  nano faz: cola tudo primeiro, só depois atualiza a tela.**
  - Habilitado suporte a "bracketed paste" (`goedit` não tinha
    nenhum antes) — sem isso, colar de fora do `goedit` chegava
    como uma rajada de teclas individuais, cada uma disparando
    sugestão/redesenho normalmente.
  - **Achado e corrigido bug de performance real**: tanto
    `InsertNewline()` quanto o snapshot de undo reconstruíam o
    array inteiro de linhas do arquivo a cada quebra de linha — um
    padrão O(n²). Colar 20 mil linhas levava **~11 segundos**
    medidos antes da correção.
  - Reescrito o colar pra acumular o texto inteiro durante o paste
    e aplicar tudo de uma vez com uma nova versão de
    `InsertTextAtCursor` que reconstrói o array **uma única vez**
    (O(n)) — as mesmas 20 mil linhas caíram pra **~1 segundo**,
    conteúdo conferido igual ponta a ponta.
  - **Bônus**: `Ctrl+Z` agora desfaz o colar inteiro numa ação só
    (testado: colar 5 linhas, um `Ctrl+Z`, volta exatamente ao
    texto original) — antes seriam milhares de pontos de desfazer
    separados, um por linha colada.
  - Corrigido também: quebra de linha **dentro** do texto colado
    estava sumindo (texto colado virava tudo uma linha só) — o
    `tcell` manda essa quebra como `KeyLF` (código 10, mesmo de
    `Ctrl+J`), um tipo de tecla que não tinha tratamento nenhum.

## v0.28.1

- **Corrigido: "dotfiles" (`.bashrc`, `.vimrc`, etc — sem nome antes
  do ponto) não formatavam nem tentavam achar estilo de comentário
  pelo shebang.** Causa: `filepath.Ext()` do próprio Go devolve o
  nome inteiro (`.bashrc`) pra esses arquivos, em vez de vazio — isso
  fazia o `goedit` tratar como "extensão conhecida mas sem formatador
  configurado" em vez de cair no fallback certo (shebang → `shfmt`
  como padrão universal). Testado abrindo um `.bashrc` de verdade:
  antes dava "sem formatador configurado", agora formata
  corretamente (confirmado com `shfmt` instalado, indentação
  aplicada dentro de uma função). Mesma correção aplicada no
  `Ctrl+/` (comentário). Realce de sintaxe não precisou de correção —
  usa o casamento de nome de arquivo do `chroma`, que já reconhecia
  `.bashrc` direto.

## v0.28.0

- **Fundo da mensagem de status (info/erro) igual o fundo da barra de
  status** — antes usava o fundo padrão do terminal, destoando do
  resto da barra; agora só a cor do texto muda, o fundo é o mesmo azul
  em ambos.
- **Esquema de cores do VS Code aplicado ao bash** (extraído por
  amostragem de pixel de capturas de tela reais, não chutado): `#`
  comentários em cinza, `function` em coral, `declare`/flags em azul
  médio, strings em azul claro, nomes de função em lilás, números em
  verde claro.
- **`$VAR`/`${VAR}` (referência de verdade) em vermelho**, mas nome
  declarado sem `$` (ex: `declare -g nTop=8`) continua na cor padrão
  — o `chroma` classifica os dois com o mesmo tipo de token, então a
  distinção é feita olhando o texto de cada token. Cobre também o
  caso de `${var}` com chaves, que o `chroma` quebra em 3 pedaços
  separados (`${`, `var`, `}`) sem o `$` grudado no nome.

## v0.27.2

- **Cabeçalho padrão em todos os arquivos `.go`** do projeto (nome,
  descrição, sites, GitHub, datas de criação/atualização, versão,
  copyright)

## v0.27.1 — redesenho da barra de status

- **Barra de status sempre na última linha da tela** — antes reservava
  uma linha extra pra prompts/mensagens, que ficava em branco boa
  parte do tempo; essa linha separada foi removida.
- **Mensagens de status (ex: "salvo") agora aparecem dentro da própria
  barra de status**, no lugar do nome do arquivo/tipo, e **somem
  sozinhas depois de 3 segundos** — mesmo sem apertar nenhuma tecla
  (timer de verdade, testado esperando parado sem tocar em nada).
  Achei e corrigi um bug sério nesse processo: um script de troca
  automática (pra converter as atribuições antigas pro novo helper
  `SetStatusMsg`) bagunçou a própria definição da função, criando uma
  **recursão infinita** que travava o programa em qualquer ação que
  mostrasse mensagem — pego e corrigido antes de entregar, com
  reteste completo confirmando a correção.
- **Busca (`Ctrl+F`) e renomear (`F2`) também aparecem dentro da barra
  de status** agora, em vez de numa linha própria.
- Confirmado que a busca já dava a volta ao chegar no fim (`F3` cicla
  de volta pra primeira ocorrência) — isso já funcionava desde antes;
  o que parecia bug em testes anteriores desta conversa era eu mesmo
  testando com a tecla errada (`Ctrl+R` em vez de `F3` de verdade).

## v0.27.0

- **Heredoc do comentário em bloco do bash trocado de `EOF` pra
  `REMARK`** (`: <<'REMARK'` ... `REMARK`)
- **Integração com o clipboard do sistema**, cobrindo Wayland E X11 —
  novo pacote `internal/sysclip`, tenta `wl-copy`/`wl-paste`, depois
  `xclip`, depois `xsel`, na ordem, testando a **execução de verdade**
  de cada um (não só se o binário existe no disco — corrigido um bug
  de design que fazia uma ferramenta "instalada mas não funcional"
  travar a detecção e nunca cair pra próxima). Testado com ferramentas
  falsas controláveis simulando: só xclip funciona, só xsel funciona,
  nenhuma funciona — todos os casos corretos, sem travar; o clipboard
  interno do goedit continua funcionando normalmente mesmo sem nenhuma
  ferramenta de sistema disponível. Agora `Ctrl+C`/`Alt+X` (cortar)
  também mandam pro clipboard do sistema, e `Ctrl+V` tenta ler de lá
  primeiro (pega texto copiado de fora do goedit também).
- **Comentário com fallback pra `#`** quando o arquivo não tem
  extensão nem shebang reconhecido — antes caía em `//` (estilo C) à
  toa. Também passou a detectar shebang (`#!/bin/bash`,
  `#!/usr/bin/env python3`, node, lua) em arquivo sem extensão, igual
  o realce de sintaxe já fazia.
- **`Ctrl+Q` pergunta antes de sair** se alguma aba tiver alteração
  não salva — menu "Salvar tudo e sair" / "Sair sem salvar" (mesmo
  estilo do menu que já existia pra fechar a última aba)

## v0.26.0

- **`Alt+X` = Cortar** — preenche o espaço que o `Ctrl+X` deixou ao
  virar "salvar e sair". Testado com copiar/colar de verdade (corta a
  linha, cola no fim, confirma que reapareceu).
- **Teclas de atalho nos itens do menu de contexto**: `Cortar` agora
  mostra `Alt+X` ao lado, igual os outros itens já mostravam
  (`Copiar Ctrl+C`, `Colar Ctrl+V`, etc)
- **Rolagem de mouse no `F1`** — antes qualquer interação de mouse
  (inclusive a roda) fechava a ajuda; agora só clique fecha, a roda
  rola o conteúdo normalmente (testado: rola sem fechar, item do topo
  sai da tela; clique continua fechando)

## v0.25.1

- **Corrigido de verdade**: removido o `Ctrl+Shift+F` da v0.25.0, que
  nunca poderia ter funcionado — confirmei com o byte real (`0x06`)
  que qualquer terminal manda pra `Ctrl+F`: é **exatamente o mesmo
  byte**, com ou sem Shift junto, sem nenhum jeito de diferenciar (só
  existem 26 códigos de controle no protocolo clássico de terminal,
  um por letra, sem variante com Shift). Reportado como não
  funcionando tanto no `xfce4-terminal` quanto no Konsole — confirma
  que é limitação do protocolo, não coisa de um terminal só.
  `Shift+Alt+F` continua sendo o atalho de teclado pra formatar
  código, e esse sim testei de ponta a ponta agora: rodei num arquivo
  Go real com formatação errada e confirmei o resultado formatado
  certinho (`x:=1` virou `x := 1`, indentação com tab, chaves no
  lugar) antes de empacotar.

## v0.25.0

- Corrigido: colchetes tinham ido pro lugar errado (aba) na versão
  anterior — agora **só no rodapé** (barra de status), como pedido:
  `[NoName]`, `[teste.txt]`. Aba voltou a mostrar o nome puro.
- **`Ctrl+Shift+F` agora formata código** (chamava busca antes, por
  causa da perda do bit de Shift em `Ctrl+letra` — mesmo problema já
  visto com outras combinações). `Ctrl+F` puro continua abrindo busca
  normalmente; `Shift+Alt+F` continua funcionando também, como opção
  extra.
- **`Ctrl+C` agora cancela qualquer prompt aberto** (busca, salvar
  como, substituir, etc), igual o `Esc` já fazia — testado: cancela o
  prompt sem sair do programa, e volta a digitar normal no texto.

## v0.24.0

- **Nome do arquivo entre colchetes** nas abas — `[NoName]`,
  `[teste.txt]`, `[*modificado.go]` (o `*` de alteração fica dentro
  dos colchetes)
- **`Ctrl+/` com comentário em bloco de verdade**: com uma seleção de
  várias linhas, em vez de só prefixar cada linha, envolve o bloco
  inteiro com os marcadores certos pra linguagem:
  - **C, Go, Java, JS/TS, Rust, etc**: `/*` numa linha, `*/` na
    última, o meio intocado
  - **bash/sh/zsh**: usa o truque clássico do heredoc redirecionado
    pro comando `:` (no-op) — `: <<'EOF'` na primeira linha, `EOF` na
    última. Testado rodando o script de verdade no bash: o bloco
    "comentado" realmente não executa nada.
  - Rodar `Ctrl+/` de novo remove os marcadores e volta ao original
    (testado: bash específico, restaura exatamente o texto original)
  - Linguagens sem suporte a bloco (Python, Lua, SQL...) continuam
    prefixando cada linha, como já era

## v0.23.0

- **Menu de contexto navegável por teclado** (`↑`/`↓`/`Enter`/`Esc`) —
  antes só respondia a clique de mouse, o que deixava qualquer fluxo
  que dependesse dele inacessível em TTY puro (console Linux sem
  X11/Wayland, sem mouse nenhum). Item destacado agora aparece com
  fundo azul diferenciado.
- **Corrigido**: `Ctrl+W` (fechar aba pelo teclado) não tinha a
  checagem de "pergunta antes se for a única aba com alteração" que a
  v0.22.0 deu pro clique no "x" — só resetava a aba direto, sem avisar
  de conteúdo não salvo. Agora usa a mesma lógica dos dois jeitos
  (mouse ou teclado), then perguntando "Salvar e fechar" / "Fechar sem
  salvar" quando faz sentido.

## v0.22.0

- Clicar no "x" da única aba aberta agora fecha o `goedit` inteiro
  (fazia sentido, já que não sobraria mais nada aberto):
  - **Sem alteração no conteúdo**: fecha direto, sem perguntar nada
  - **Com alteração**: abre um menu com "Salvar e fechar" / "Fechar
    sem salvar" — só fecha depois da escolha. Se o arquivo ainda não
    tem nome, "Salvar e fechar" pede o caminho antes.
  - Com mais de uma aba aberta, continua fechando só aquela aba,
    normalmente

## v0.21.0

- **Posição de cursor salva por arquivo** — ao fechar um arquivo (aba
  com `Ctrl+W`, ou o editor inteiro com `Ctrl+Q`/`Ctrl+X`), a linha e
  coluna onde o cursor estava são salvas em
  `~/.config/goedit/positions.json`. Reabrir o mesmo arquivo depois
  (mesma sessão ou uma nova) restaura o cursor exatamente ali. Se o
  arquivo mudou de tamanho entre uma sessão e outra, a posição é
  ajustada pros limites atuais em vez de travar ou ficar fora do
  conteúdo.
- Rótulo de arquivo novo/sem caminho trocado pra "NoName" (era "sem
  título", depois "sem nome" — assentou nessa)

## v0.20.3

- Rótulo de arquivo novo/sem caminho trocado de "sem título" pra
  "sem nome"

## v0.20.2

- `Ctrl+X` num arquivo sem nome (`sem título`) que **não foi
  modificado** agora sai direto, sem perguntar "Salvar como:" à toa —
  não tem nada de fato pra salvar. Se o buffer tiver alguma alteração
  (mesmo sem nome ainda), continua pedindo o caminho normalmente.
- Corrigido no processo: `Ctrl+X` só funcionava quando a sidebar
  **não** estava com foco (só existia dentro do tratamento de teclas
  do editor) — por isso, abrir o goedit sem argumento (que já começa
  com a sidebar focada) fazia o `Ctrl+X` não responder a nada até
  apertar `Esc` primeiro. Agora funciona de qualquer lugar, igual o
  `Ctrl+Q` já fazia.

## v0.20.1

- **`Ctrl+L` sem split ativo** agora repete a última busca (mesmo
  comportamento do `F3`) — antes não fazia nada, já que só existia 1
  painel pra trocar o foco. Com split ativo, continua trocando de
  painel normalmente.

## v0.20.0

- **`Ctrl+K` agora copia a linha pro clipboard antes de apagar** (dá
  pra colar de volta com `Ctrl+V`) — mesmo comportamento que o
  `Ctrl+X` tinha antes
- **`Ctrl+X` virou "salvar e sair"** — se o arquivo ainda não tem
  caminho, espera o prompt "Salvar como:" terminar antes de sair; se
  der erro ao salvar, não sai (evita perder conteúdo sem aviso)

## v0.19.0

- **`F1` — tela de ajuda** com a lista completa de atalhos, organizada
  por seção (Arquivo, Navegação, Busca, Editar, Seleção, F2, Autocompletar,
  Sidebar, Comandos). Rolável com `↑`/`↓`/`Page Up`/`Page Down`; `F1`,
  `Esc` ou clicar em qualquer lugar fecha.
- Confirmado que `Ctrl+L` já tinha função própria (trocar foco entre
  painéis do split) — mantido como está, sem sobrepor.

## v0.18.1

- **Syntax highlighting muito mais completo**, principalmente em bash
  (mas vale pra outras linguagens também): variáveis (`$VAR`, `$1`,
  `$i`), comandos embutidos (`echo`, `local`, `cd`, `export`...),
  constantes, classes/namespaces e tags/decoradores agora recebem cor
  própria. Antes, o mapeamento de cores só tratava nomes de função
  especificamente — tudo mais na categoria "Name" do `chroma`
  (que inclui variável e builtin, bem comuns em scripts) caía sem cor
  nenhuma. Confirmado com um script bash real: antes a maioria dos
  tokens de variável/comando ficava sem cor; agora ficam.

## v0.18.0

- **Destaque visual do termo buscado** (`Ctrl+F`), igual VS Code/nano —
  antes o cursor só pulava pra ocorrência, sem marcar nada visualmente.
  Fundo amarelo no trecho encontrado; `F3` repete a busca e move o
  destaque pra próxima ocorrência; digitar, apagar ou `Esc` limpa o
  destaque.

## v0.17.1

- **Correção de performance real**, medida com instrumentação de tempo
  (não suposição): a chave do cache de sintaxe incluía sempre a 1ª
  linha do arquivo, mesmo em arquivos com extensão reconhecida (onde
  ela nunca deveria importar) — editar a 1ª linha invalidava o
  highlight cacheado do arquivo inteiro. Também: contagem de palavras
  na barra de status agora tem cache (era recalculada em todo frame,
  mesmo sem editar nada), e o autocompletar ganhou um teto de
  caracteres varridos por chamada. Resultado medido: arquivo de 500
  linhas caiu de ~9-14ms por tecla pra menos de 1.5ms.

## v0.17.0

Varredura sistemática do modo de seleção em bloco/coluna, testando
sistematicamente (não só reagindo a bug reportado) todas as teclas que
fazem sentido durante a marcação: setas com e sem `Ctrl+Shift`,
`Home`/`End`, `Ctrl+S`, `Delete`/`Backspace`, `Ctrl+C`/`Ctrl+X`/`Ctrl+V`,
`Esc`, mouse.

- **Corrigido bug de roteamento sério**: quando uma tecla não reconhecida
  cancelava o modo bloco, ela era **descartada silenciosamente** em vez
  de continuar pro editor normal. Isso fazia setas comuns, `Home`,
  `End`, `Ctrl+S` e outros atalhos apertados durante a marcação
  cancelarem o bloco **e não fazerem mais nada** — a tecla se perdia.
  Agora cai certinho pro fluxo normal do editor depois de cancelar.
- **Mouse durante a marcação**: clicar em qualquer lugar agora cancela
  a seleção em bloco pendente corretamente (antes ficava em estado
  inconsistente)
- **`Ctrl+C`/`Ctrl+X` novos**: copiar e recortar o retângulo marcado
  (uma "fatia" de cada linha, sem juntar com o resto do texto),
  colável depois com `Ctrl+V` normalmente — igual o VS Code faz com
  seleção em coluna

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
