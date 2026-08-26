-- Remove espaços em branco no fim de TODAS as linhas do arquivo —
-- útil antes de salvar/commitar, evita diffs sujos por espaço
-- invisível sobrando.
goedit.register_command("Remover espacos no fim das linhas", function()
	local total = goedit.line_count()
	local removidos = 0
	for i = 0, total - 1 do
		local linha = goedit.get_line(i)
		local sem_espacos = linha:gsub("%s+$", "")
		if sem_espacos ~= linha then
			goedit.set_line(i, sem_espacos)
			removidos = removidos + 1
		end
	end
	goedit.notify(removidos .. " linha(s) tiveram espaços removidos")
end)
