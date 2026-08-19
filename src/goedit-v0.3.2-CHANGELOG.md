# Changelog

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
