-- Alterna a linha atual entre TUDO MAIÚSCULO e tudo minúsculo —
-- roda de novo pra voltar.
goedit.register_command("Alternar maiusculas/minusculas", function()
	local _, y = goedit.get_cursor()
	local linha = goedit.get_line(y)
	if linha == string.upper(linha) and linha ~= string.lower(linha) then
		goedit.set_line(y, string.lower(linha))
	else
		goedit.set_line(y, string.upper(linha))
	end
end)
