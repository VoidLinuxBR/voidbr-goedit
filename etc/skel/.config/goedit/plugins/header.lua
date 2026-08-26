-- Insere um cabeçalho de arquivo respeitando o estilo de comentário
-- de cada linguagem — bloco /* */ em C/Go/Java/JS/etc, # em
-- bash/Python/etc. Segue a mesma lógica do próprio goedit: extensão
-- primeiro, shebang se o arquivo não tiver extensão, # como padrão
-- universal por último.
--
-- Também insere o shebang (#!/bin/bash, #!/usr/bin/env python3...)
-- quando faz sentido pro tipo do arquivo (scripts executáveis) — pra
-- tipos que não usam shebang de verdade (.txt, .go, .c, .java...)
-- não insere nenhum. Se o arquivo já tiver um shebang na primeira
-- linha, não duplica.
local dias = {"dom", "seg", "ter", "qua", "qui", "sex", "sab"}
local meses = {"jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"}

local c_like = {
	c = true, h = true, cpp = true, hpp = true, cc = true, java = true,
	js = true, ts = true, jsx = true, tsx = true, rs = true, swift = true,
	kt = true, cs = true, php = true, scala = true, dart = true,
	css = true, go = true,
}

-- só linguagens de script de verdade, que fazem sentido rodar direto
-- com #!/caminho — .go/.c/.java são compilados, .txt não é código
-- nenhum, .css/.json/etc não têm conceito de "executável".
local shebang_map = {
	sh = "#!/usr/bin/env bash",
	bash = "#!/usr/bin/env bash",
	py = "#!/usr/bin/env python3",
	rb = "#!/usr/bin/env ruby",
	pl = "#!/usr/bin/env perl",
}

local function ext_of(path)
	local e = path:match("%.([%w]+)$")
	return e and e:lower() or nil
end

-- Se não tem extensão, tenta pelo shebang (#!/bin/bash, #!/usr/bin/env
-- python3, etc) — mesma ideia do goedit pro formatador/comentário.
local function estilo_por_shebang(primeira_linha)
	if not primeira_linha:match("^#!") then
		return nil
	end
	if primeira_linha:match("node") then
		return "c"
	end
	return "hash" -- bash, sh, python, perl, ruby... todos usam #
end

goedit.register_command("Inserir cabecalho de arquivo", function()
	local t = os.date("*t")
	local hoje = string.format("%s %02d %s %d %02d:%02d:%02d -04",
		dias[t.wday], t.day, meses[t.month], t.year, t.hour, t.min, t.sec)
	local nome = goedit.filename()
	local nome_exibido = nome ~= "" and nome or "(sem nome)"

	local e = nome ~= "" and ext_of(nome) or nil

	local estilo = "hash" -- padrão universal, igual o goedit usa
	if e and c_like[e] then
		estilo = "c"
	elseif not e then
		local por_shebang = estilo_por_shebang(goedit.get_line(0))
		if por_shebang then
			estilo = por_shebang
		end
	end

	-- corpo SEM \n no final -- quem insere decide exatamente 1 quebra
	-- de linha de transição em cada caso, pra não sobrar linha em
	-- branco extra (nem faltar).
	local corpo
	if estilo == "c" then
		corpo = "/*\n   " .. nome_exibido .. "\n   Criado em: " .. hoje .. "\n   Updated:  " .. hoje .. "\n*/"
	else
		corpo = "# " .. nome_exibido .. "\n# Criado em: " .. hoje .. "\n# Updated:  " .. hoje
	end

	local primeira_linha_atual = goedit.get_line(0)
	local ja_tem_shebang = primeira_linha_atual:match("^#!") ~= nil
	local shebang_desejado = e and shebang_map[e] or nil

	if ja_tem_shebang then
		-- já tem shebang: não duplica, só insere o cabeçalho DEPOIS
		-- dele (shebang tem que continuar sendo a 1ª linha de verdade).
		-- SEM \n no final aqui -- diferente dos outros dois casos, a
		-- linha seguinte original já existe intocada logo depois do
		-- cursor; um \n a mais aqui sobraria como linha em branco.
		goedit.set_cursor(#primeira_linha_atual, 0)
		goedit.insert_text("\n" .. corpo)
		goedit.notify("cabeçalho inserido depois do shebang existente")
	elseif shebang_desejado then
		goedit.set_cursor(0, 0)
		goedit.insert_text(shebang_desejado .. "\n" .. corpo .. "\n")
		goedit.notify("cabeçalho inserido com shebang (" .. shebang_desejado .. ")")
	else
		goedit.set_cursor(0, 0)
		goedit.insert_text(corpo .. "\n")
		goedit.notify("cabeçalho inserido (estilo " .. estilo .. ", sem shebang — não se aplica a esse tipo)")
	end
end)
