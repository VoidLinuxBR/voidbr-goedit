<div align="center">

# goedit

**Editor de texto de terminal (TUI) em Go** — abas, split, sidebar, syntax
highlighting, autocompletar, menu de contexto, seleção em bloco, formatador
de código, plugins em Lua e um `F2` de renomear ao vivo que dá gosto de usar.

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
- 🧠 **Autocompletar** por palavras do buffer, com popup navegável
  (não é IntelliSense semântico — busca textual no que já foi escrito)
- 🖱️ **Menu de contexto** (botão direito) nas abas, no texto e na sidebar
- 🟦 **Seleção em bloco/coluna** (`Ctrl+Shift+setas`), igual o VS Code
- 🧹 **Formatador de código** externo por linguagem (`gofmt`, `shfmt`,
  `prettier`, via `Shift+Alt+F`)
- 📐 **Sidebar redimensionável** (arrasta a divisória) e com busca
  incremental por digitação

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
goedit *.sh            # abre todos os arquivos que baterem, um por aba
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
| `Ctrl+Shift+↑`/`↓`/`←`/`→` | Seleção em bloco/coluna — marca um retângulo de texto (mesma faixa de colunas em várias linhas), digitar troca em todas as linhas marcadas de uma vez. `Enter` confirma, `Esc` cancela |
| `Shift+Alt+F` | Formatar código com o formatador externo da linguagem (`gofmt`, `shfmt`, etc — precisa estar instalado) |
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
navegar com `↑`/`↓`/`Page Up`/`Page Down`/`Home`/`End`), `Ctrl+B` de novo
(ou `Esc`) desliga. A entrada `../` no topo da lista (quando não está na
raiz) volta pra pasta anterior — clicável ou com `Enter`. Clicar num
arquivo abre ele numa aba sem fechar a sidebar (só `Ctrl+B` fecha).
Digitar letras faz busca incremental (tipo explorador de arquivos): `f`
pula pro primeiro item que começa com "f", digitar mais letras em
seguida refina a busca; parar de digitar reinicia do zero na próxima
tecla.

## Mouse

| Ação | Efeito |
|---|---|
| Clique no texto | Posiciona o cursor ali |
| Clique + arrasto no texto | Seleciona o trecho arrastado |
| Clique numa aba | Troca pra aquele buffer |
| Clique no "x" de uma aba | Fecha aquela aba |
| Clique direito numa aba | Abre menu: Fechar / Fechar outras / Fechar todas / Salvar |
| Clique direito no texto | Abre menu: Copiar / Cortar / Colar / Selecionar tudo / Formatar código |
| Clique num item da sidebar | Abre o arquivo, ou entra na pasta |
| Clique direito no título "SIDEBAR" | Abre menu: Fechar / Atualizar |
| Clique no "x" do título da sidebar | Fecha a sidebar (igual `Ctrl+B`) |
| Arrastar a divisória (│) da sidebar | Redimensiona a largura dela |
| Roda do mouse | Rola o texto, cursor acompanha a linha do ponteiro |

> **Nota:** com o mouse do editor ligado, o terminal encaminha todos os
> cliques pro goedit em vez de mostrar o menu nativo dele. Isso é padrão
> em qualquer app de terminal com mouse habilitado (Vim, etc.), não é
> específico do goedit. Pra usar o menu/seleção nativo do **terminal**
> (copiar pro clipboard do sistema, por exemplo), segura `Shift` enquanto
> clica — funciona na maioria dos terminais baseados em VTE
> (xfce4-terminal, gnome-terminal) e no xterm.

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

## Autocompletar

Digitar 2 ou mais letras de um identificador abre um popup com palavras
já usadas no arquivo que começam com isso — busca textual no que já foi
escrito (tipo o keyword completion nativo do Vim), **não é IntelliSense
semântico**: não entende tipos, escopo, nem é ciente da linguagem.

- `↓` / `↑`: navega entre as sugestões
- `Tab` ou `Enter`: aceita a sugestão selecionada
- `Esc`: cancela
- Continuar digitando refina a busca; apagar/mover o cursor fecha o popup

## Formatador de código

`Shift+Alt+F` ou "Formatar código" no menu de contexto do texto roda um
formatador externo (um programa de verdade instalado no sistema, não algo
embutido no goedit) de acordo com a extensão do arquivo:

| Extensão | Formatador |
|---|---|
| `.go` | `gofmt` |
| `.sh`, `.bash` | `shfmt` |
| `.yml`, `.yaml` | `prettier` |
| sem extensão | tenta pelo shebang; sem shebang, usa `shfmt` como padrão |

Precisa do binário instalado e no `$PATH` — se não tiver, mostra uma
mensagem clara em vez de travar. Pra adicionar mais linguagens, edita o
mapa `formattersByExt` em `internal/ui/format.go`.

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
  ├─ suggest.go            autocompletar por palavras do buffer
  ├─ blockselect.go        seleção em bloco/coluna
  ├─ format.go             formatador de código externo
  └─ mouse.go              clique, arrasto, roda, menus de contexto
internal/config/         caminhos de configuração
examples/plugins/        plugin Lua de exemplo
```

## Limitações conhecidas

Base sólida e funcional, não uma réplica 1:1 de editores gráficos: undo é
por snapshot de buffer (não granular por caractere), busca sem regex, e o
**split** (`Ctrl+\`) mostra 2 painéis fixos sem redimensionar (diferente
da sidebar, essa sim redimensionável por arrasto). Dá pra evoluir a
partir daqui — ver [`CHANGELOG.md`](CHANGELOG.md) pro histórico de versões.

## Contribuindo

Issues e PRs são bem-vindos. Antes de mandar um PR, roda `gofmt -w .` e
`go vet ./...` — e se mexer em comportamento de teclado/mouse, testa de
verdade (o projeto inteiro foi construído testando cada atalho num pty
real, não só lendo o código).

## Licença

[MIT](LICENSE)
