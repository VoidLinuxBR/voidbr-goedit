-- Insere a data/hora no formato "qua 26 ago 2026 04:07:09 -04" na
-- posição do cursor. os.date("%a"/"%b") do Lua embutido no goedit
-- não é confiável (sempre devolve nomes em inglês, errados) — por
-- isso monta o dia da semana e o mês na mão.
local dias = {"dom", "seg", "ter", "qua", "qui", "sex", "sab"}
local meses = {"jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"}

goedit.register_command("Inserir data", function()
	local t = os.date("*t")
	local formatado = string.format("%s %02d %s %d %02d:%02d:%02d -04",
		dias[t.wday], t.day, meses[t.month], t.year, t.hour, t.min, t.sec)
	goedit.insert_text(formatado)
	goedit.notify("Data inserida: " .. formatado)
end)
