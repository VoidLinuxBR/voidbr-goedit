-- Conta quantas palavras tem na linha atual (a barra de status já
-- mostra o total do arquivo, isso é só a linha onde o cursor está).
goedit.register_command("Contar palavras da linha", function()
	local _, y = goedit.get_cursor()
	local linha = goedit.get_line(y)
	local _, n = linha:gsub("%S+", "")
	goedit.notify("Linha " .. (y + 1) .. ": " .. n .. " palavra(s)")
end)
