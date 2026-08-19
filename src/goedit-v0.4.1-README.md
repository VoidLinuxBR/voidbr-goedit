# goedit

Editor de texto de terminal (TUI) em Go, com abas, split de painéis, sidebar
de arquivos, syntax highlighting, busca/substituição, undo/redo e plugins em
Lua.

## Build

Precisa do Go instalado (>= 1.21) e internet normal (o `go.sum` não vem no
pacote — a primeira build baixa e resolve as dependências sozinha):

```sh
go mod tidy
go build -o goedit .
```

Ou, pra um binário estático (roda em qualquer distro Linux, sem depender de
libs do sistema):

```sh
CGO_ENABLED=0 go build -ldflags="-s -w" -o goedit .
```

## Uso

```sh
./goedit            # abre sem arquivo (buffer novo)
./goedit arquivo.go  # abre um arquivo direto
```

## Atalhos

| Tecla | Ação |
|---|---|
| `Ctrl+S` | Salvar |
| `Ctrl+O` | Abrir arquivo (digita o caminho) |
| `Ctrl+N` | Nova aba vazia |
| `Ctrl+W` | Fechar aba atual |
| `Alt+←` / `Alt+→` | Aba anterior / próxima |
| `Ctrl+B` | Mostrar/ocultar sidebar de arquivos |
| `Ctrl+\` | Abrir/fechar split (2 painéis lado a lado) |
| `Ctrl+L` | Trocar foco entre painéis |
| `Ctrl+F` | Buscar |
| `F3` | Repetir última busca |
| `Ctrl+H` | Buscar e substituir |
| `Ctrl+G` | Ir para linha (digita o número) |
| `F2` | Renomear ao vivo — destaca todas as ocorrências exatas da palavra sob o cursor (inclui hífen no nome, tipo `void-install` — trata como um token só; a seleção no texto principal, se houver, não muda o alvo, igual o VS Code com LSP) e atualiza o texto conforme você digita. O cursor do campo começa na mesma posição relativa que estava na palavra (início/meio/fim). Dentro do campo: `Shift+←/→/Home/End` marca um trecho do nome, e digitar por cima substitui só aquele trecho (local); sem marcação, digitar insere/sobrescreve normalmente na posição do cursor (respeitando `Insert`). `Enter` confirma, `Esc` cancela |
| `Ctrl+Z` | Desfazer (agrupa digitação contínua num passo só) |
| `Ctrl+Y` | Refazer |
| `Ctrl+U` | Desfazer (atalho extra, igual ao `Ctrl+Z`) |
| `Ctrl+A` | Selecionar tudo |
| `Shift+setas` / `Shift+Home` / `Shift+End` | Estender seleção |
| `Ctrl+C` | Copiar seleção |
| `Ctrl+X` | Recortar seleção (ou a linha atual, se nada selecionado) |
| `Ctrl+V` | Colar |
| `Ctrl+D` | Duplicar linha atual |
| `Alt+↑` / `Alt+↓` | Mover linha atual pra cima/baixo |
| `Ctrl+/` | Comentar/descomentar linha atual |
| `Ctrl+K` | Apagar linha atual (equivalente ao `Ctrl+Shift+K` do VS Code — ver nota abaixo) |
| `Delete` | Apagar caractere à frente do cursor (ou a seleção, se houver) |
| `Insert` | Alterna entre modo inserir e sobrescrever (mostra `INS`/`OVR` na barra de status) |
| `Tab` (com seleção) | Indenta as linhas selecionadas |
| `Shift+Tab` | Remove um nível de indentação (da linha atual, ou de cada linha selecionada) |
| `Ctrl+Home` / `Ctrl+End` | Início / fim do arquivo |
| `Ctrl+P` | Paleta de comandos (roda comandos registrados por plugins) |
| `Ctrl+Q` | Sair |

> **Nota sobre `Ctrl+Shift+<tecla>`:** na maioria dos terminais, `Ctrl+Shift+K`
> chega no programa com o mesmo código de `Ctrl+K` puro — o bit de "shift"
> se perde nessas combinações. Por isso o atalho de apagar linha responde a
> `Ctrl+K` sozinho, sem precisar do Shift. Combinações com `Shift+seta`
> (usadas na seleção de texto) não têm esse problema — chegam como
> sequências distintas e funcionam normalmente.

Na sidebar: `↑`/`↓` navega, `Enter` abre arquivo ou entra na pasta,
`Backspace` sobe um nível, `Esc` ou `Ctrl+B` sai da sidebar.

**A sidebar começa desligada** ao abrir o editor — a área de edição ocupa a
tela inteira de cara. Aperte `Ctrl+B` quando quiser ver a lista de arquivos
(ela abre já focada, pronta pra navegar com as setas); aperte `Ctrl+B` de
novo (ou `Esc`) pra fechar e voltar o foco pro texto.

## Configuração (tabulação e afins)

Fica em `~/.config/goedit/settings.json` — o arquivo não existe até você
criar um; sem ele, os padrões são `tabWidth: 4` e `insertSpaces: true`.

```json
{
  "tabWidth": 4,
  "insertSpaces": true
}
```

- `tabWidth`: quantas colunas uma tabulação ocupa na tela, e quantos
  espaços a tecla `Tab` insere (quando `insertSpaces` é `true`).
- `insertSpaces`: `true` insere espaços ao apertar `Tab` (padrão da
  maioria dos editores modernos); `false` insere um caractere de
  tabulação de verdade (`\t`).

Isso só afeta o que a tecla `Tab` insere — arquivos abertos que já têm
tabulação real (`\t`) sempre são exibidos respeitando `tabWidth`,
independente do valor de `insertSpaces`.

## Plugins (Lua)

Coloque arquivos `.lua` em `~/.config/goedit/plugins/` — são carregados
automaticamente ao abrir o editor. Um plugin registra comandos que aparecem
na paleta (`Ctrl+P`):

```lua
goedit.register_command("ola", function()
    goedit.notify("Ola! Isso veio de um plugin Lua.")
end)
```

API disponível dentro dos scripts, via a tabela global `goedit`:

| Função | Descrição |
|---|---|
| `goedit.get_line(y)` | devolve o texto da linha `y` (0-indexed) |
| `goedit.set_line(y, texto)` | substitui o conteúdo da linha `y` |
| `goedit.line_count()` | número de linhas do buffer atual |
| `goedit.get_cursor()` | devolve `x, y` do cursor |
| `goedit.set_cursor(x, y)` | move o cursor |
| `goedit.insert_text(texto)` | insere texto na posição do cursor |
| `goedit.filename()` | caminho do arquivo atual |
| `goedit.notify(msg)` | mostra uma mensagem na barra inferior |
| `goedit.register_command(nome, fn)` | registra um comando pra paleta |

Veja `examples/plugins/exemplo.lua` pra mais exemplos (maiúsculas, inserir
data).

## Arquitetura

```
main.go                      ponto de entrada, loop de eventos
internal/buffer/             texto do arquivo + undo/redo (snapshots)
internal/syntax/              highlight via chroma
internal/plugin/              runtime Lua (gopher-lua) + API do editor
internal/ui/                  tcell: desenho de tela, tabs, sidebar, split
internal/config/              caminhos de configuração
examples/plugins/             plugin Lua de exemplo
```

## Mouse

O editor responde a mouse (clique, arrasto e roda), num terminal que passe
os eventos pra frente (a maioria passa: kitty, foot, alacritty, xterm...).

| Ação | Efeito |
|---|---|
| Clique no texto | Posiciona o cursor ali |
| Clique + arrasto no texto | Seleciona o trecho arrastado |
| Clique numa aba | Troca pra aquele buffer |
| Clique num item da sidebar | Abre o arquivo, ou entra na pasta |
| Roda do mouse (scroll) | Rola o texto (3 linhas por “clique” da roda) |

O scroll do mouse move o cursor junto (não existe rolagem "solta" da
tela independente do cursor neste editor) — é assim que muitos editores
de terminal fazem, já que o redesenho sempre mantém o cursor visível.

## Detecção de linguagem (destaque de sintaxe)

Arquivos com extensão (`.go`, `.py`, `.js`...) usam a extensão direto. Pra
arquivos **sem extensão** (scripts tipo `deploy`, `build`, `meu-programa`),
a ordem é:

1. Lê a primeira linha em busca de shebang (`#!/usr/bin/env python3`,
   `#!/bin/bash`, etc.) e usa a linguagem citada ali.
2. Se não tiver shebang nenhum, usa **bash** como padrão — é o caso mais
   comum de script sem extensão no dia a dia.

## Limitações conhecidas

Isso é uma base sólida e funcional, não uma réplica 1:1 do Notepad++:
undo é por snapshot de buffer inteiro (não granular por caractere), não
tem regex na busca, não tem mouse pra seleção de texto ainda, e o split
mostra 2 painéis fixos (sem redimensionar). Dá pra evoluir a partir daqui.
