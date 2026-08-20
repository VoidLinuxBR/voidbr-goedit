<div align="center">

# goedit

**Editor de texto de terminal (TUI) em Go** — abas, split, sidebar, syntax
highlighting, plugins em Lua e um `F2` de renomear ao vivo que dá gosto de usar.

![Go version](https://img.shields.io/badge/Go-1.21%2B-00ADD8?logo=go&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-experimental-orange)

</div>

---

## Por quê

Precisava de um editor de terminal rápido, sem dependências malucas, com o
básico que todo editor moderno tem (abas, sidebar, undo de verdade, mouse,
plugins) — e um `F2` de renomear que atualiza tudo **ao vivo, inline**, sem
sair do lugar onde você está digitando. Não é (nem quer ser) um clone do
Vim ou do Notepad++; é um ponto de partida sólido, testado de verdade a
cada mudança, pra evoluir conforme o uso pedir.

## Recursos

- 📑 **Abas** (múltiplos buffers) e **split** de painel lado a lado
- 📂 **Sidebar** de arquivos navegável pelo teclado ou mouse
- 🎨 **Syntax highlighting** via [chroma](https://github.com/alecthomas/chroma),
  com detecção automática por extensão **ou por shebang** em scripts sem
  extensão (`#!/usr/bin/env python3` → Python; sem shebang → bash)
- ↩️ **Undo/redo** que agrupa digitação contínua num passo só (como
  qualquer editor decente deveria fazer)
- 🖱️ **Mouse**: clique posiciona cursor, arrasto seleciona, roda rola o
  texto acompanhando o ponteiro
- 🔍 **Busca**, buscar/substituir, ir para linha
- ✏️ **`F2` — renomear ao vivo, inline**: destaca todas as ocorrências
  exatas do token sob o cursor e atualiza tudo em tempo real conforme
  você digita, sem sair do lugar. Cursor sempre no texto, nunca numa
  caixinha separada.
- 🧩 **Plugins em Lua** — scripts rodáveis pela paleta de comandos
- ⚙️ Indentação configurável, comentar/descomentar, duplicar/mover linha,
  modo overwrite, e o resto do repertório que se espera de um editor sério

## Instalação

Precisa do [Go](https://go.dev) 1.21 ou mais novo.

```sh
git clone <url-do-repositorio>
cd goedit
go mod tidy
go build -o goedit .
```

Binário estático (não depende de libs do sistema, roda em qualquer distro Linux):

```sh
CGO_ENABLED=0 go build -ldflags="-s -w" -o goedit .
```

Coloca no `$PATH` e pronto:

```sh
cp goedit ~/.local/bin/goedit
```

## Uso

```sh
goedit                 # abre sem arquivo (buffer novo)
goedit arquivo.go      # abre um arquivo direto
goedit --version       # mostra a versão instalada
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
| `F2` | Renomear ao vivo, **inline** — o cursor fica no próprio texto principal (na ocorrência onde você apertou F2), não numa linha separada. Destaca todas as ocorrências exatas do token sob o cursor (só corta em espaço, `=`, `"` e `'`) e atualiza tudo ao vivo conforme você digita. `Shift+←/→/Home/End` marca um trecho do nome pra trocar só ele; sem marcação, digitar insere/sobrescreve normalmente (respeitando `Insert`). `Enter` confirma, `Esc` cancela |
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
| `Ctrl+K` | Apagar linha atual |
| `Delete` | Apagar caractere à frente do cursor (ou a seleção, se houver) |
| `Insert` | Alterna entre modo inserir e sobrescrever (mostra `INS`/`OVR` na barra de status) |
| `Tab` (com seleção) | Indenta as linhas selecionadas |
| `Shift+Tab` | Remove um nível de indentação |
| `Ctrl+Home` / `Ctrl+End` | Início / fim do arquivo |
| `Ctrl+P` | Paleta de comandos (roda comandos registrados por plugins) |
| `Ctrl+Q` | Sair |

<details>
<summary><strong>Nota sobre Ctrl+Shift+&lt;tecla&gt;</strong></summary>

Na maioria dos terminais, `Ctrl+Shift+K` chega no programa com o mesmo
código de `Ctrl+K` puro — o bit de "shift" se perde nessas combinações.
Por isso o atalho de apagar linha responde a `Ctrl+K` sozinho. Combinações
com `Shift+seta` (usadas na seleção de texto) não têm esse problema —
chegam como sequências distintas e funcionam normalmente.
</details>

A sidebar começa **desligada** — `Ctrl+B` liga (já focada, pronta pra
navegar com as setas), `Ctrl+B` de novo (ou `Esc`) desliga.

## Mouse

| Ação | Efeito |
|---|---|
| Clique no texto | Posiciona o cursor ali |
| Clique + arrasto no texto | Seleciona o trecho arrastado |
| Clique numa aba | Troca pra aquele buffer |
| Clique num item da sidebar | Abre o arquivo, ou entra na pasta |
| Roda do mouse | Rola o texto, cursor acompanha a linha do ponteiro |

## Configuração

`~/.config/goedit/settings.json` (opcional — sem ele, os padrões valem):

```json
{
  "tabWidth": 4,
  "insertSpaces": true
}
```

- `tabWidth`: colunas que uma tabulação ocupa na tela, e espaços que `Tab` insere.
- `insertSpaces`: `true` insere espaços ao apertar `Tab`; `false` insere `\t` de verdade.

## Plugins (Lua)

Arquivos `.lua` em `~/.config/goedit/plugins/` são carregados automaticamente:

```lua
goedit.register_command("ola", function()
    goedit.notify("Ola! Isso veio de um plugin Lua.")
end)
```

Roda pela paleta de comandos (`Ctrl+P`). API completa e mais exemplos em
[`examples/plugins/exemplo.lua`](examples/plugins/exemplo.lua).

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

## Detecção de linguagem

Arquivos com extensão usam a extensão direto. Sem extensão (scripts tipo
`deploy`, `build`): lê o shebang da 1ª linha (`#!/usr/bin/env python3` →
Python); sem shebang nenhum, cai pro **bash** como padrão.

## Arquitetura

```
main.go                  ponto de entrada, loop de eventos
internal/buffer/         texto do arquivo + undo/redo (snapshots)
internal/syntax/         highlight via chroma
internal/plugin/         runtime Lua (gopher-lua) + API do editor
internal/ui/              tcell: desenho de tela, tabs, sidebar, split, mouse
internal/config/         caminhos de configuração
examples/plugins/        plugin Lua de exemplo
```

## Limitações conhecidas

Base sólida e funcional, não uma réplica 1:1 de editores gráficos: undo é
por snapshot de buffer (não granular por caractere), busca sem regex, e o
split mostra 2 painéis fixos sem redimensionar. Dá pra evoluir a partir
daqui — ver [`CHANGELOG.md`](CHANGELOG.md) pro histórico de versões.

## Contribuindo

Issues e PRs são bem-vindos. Antes de mandar um PR, roda `gofmt -w .` e
`go vet ./...` — e se mexer em comportamento de teclado/mouse, testa de
verdade (o projeto inteiro foi construído testando cada atalho num pty
real, não só lendo o código).

## Licença

[MIT](LICENSE)
