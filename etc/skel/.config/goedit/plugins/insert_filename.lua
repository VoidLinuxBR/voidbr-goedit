-- Insere o caminho do arquivo atual na posição do cursor — útil em
-- logs, comentários de topo, mensagens de erro customizadas, etc.
goedit.register_command("Inserir nome do arquivo", function()
	local nome = goedit.filename()
	if nome == "" then
		goedit.notify("arquivo ainda não foi salvo, sem nome pra inserir")
		return
	end
	goedit.insert_text(nome)
end)
