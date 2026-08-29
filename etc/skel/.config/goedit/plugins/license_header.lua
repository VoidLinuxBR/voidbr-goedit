-- Insere um cabeçalho de licença completo (estilo BSD, ChiliLinux) —
-- adapta ao estilo de comentário de cada linguagem: # em bash/
-- Python/etc, bloco /* */ em C/Go/Java/etc. Em bash/sh especificamente,
-- também inclui as linhas de coding/shellcheck. Segue a mesma lógica
-- de detecção de tipo do goedit (extensão → shebang → # como padrão).
local dias = {"dom", "seg", "ter", "qua", "qui", "sex", "sab"}
local meses = {"jan", "fev", "mar", "abr", "mai", "jun", "jul", "ago", "set", "out", "nov", "dez"}

local c_like = {
	c = true, h = true, cpp = true, hpp = true, cc = true, java = true,
	js = true, ts = true, jsx = true, tsx = true, rs = true, swift = true,
	kt = true, cs = true, php = true, scala = true, dart = true,
	css = true, go = true,
}

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

local function basename(path)
	return path:match("([^/\\]+)$") or path
end

local function estilo_por_shebang(primeira_linha)
	if not primeira_linha:match("^#!") then
		return nil
	end
	if primeira_linha:match("node") then
		return "c"
	end
	return "hash"
end

-- corpo da licença em si — sem marcador de comentário, isso é
-- adicionado depois conforme o estilo (# ou dentro do /* */).
local licenca_linhas = {
	"",
	"Copyright (c) 2019-2026, Vilmar Catafesta <vcatafesta@gmail.com>",
	"Copyright (c) 2019-2026, ChiliLinux Development Team <https://chililinux.com> <https://github.com/chililinux>",
	"Copyright (c) 2026-2026, VoidBR Development Team <https://voidbr.org> <https://github.com/voidlinuxbr>",
	"Assembled By Vilmar Catafesta for the ChiliLinux project.",
	"Assembled By Vilmar Catafesta for the VoidBR project.",
	"All rights reserved.",
	"",
	"Redistribution and use in source and binary forms, with or without",
	"modification, are permitted provided that the following conditions",
	"are met:",
	"1. Redistributions of source code must retain the above copyright",
	"   notice, this list of conditions and the following disclaimer.",
	"2. Redistributions in binary form must reproduce the above copyright",
	"   notice, this list of conditions and the following disclaimer in the",
	"   documentation and/or other materials provided with the distribution.",
	"",
	"THIS SOFTWARE IS PROVIDED BY Vilmar Catafesta ''AS IS'' AND ANY EXPRESS OR",
	"IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES",
	"OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.",
	"IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,",
	"INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT",
	"NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,",
	"DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY",
	"THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT",
	"(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF",
	"THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.",
}

goedit.register_command("Inserir licenca completa", function()
	local t = os.date("*t")
	local hoje = string.format("%s %02d %s %d %02d:%02d:%02d -04",
		dias[t.wday], t.day, meses[t.month], t.year, t.hour, t.min, t.sec)
	local nome = goedit.filename()
	local nome_curto = nome ~= "" and basename(nome) or "(sem nome)"
	local e = nome ~= "" and ext_of(nome) or nil

	local estilo = "hash"
	if e and c_like[e] then
		estilo = "c"
	elseif not e then
		local por_shebang = estilo_por_shebang(goedit.get_line(0))
		if por_shebang then
			estilo = por_shebang
		end
	end

	-- monta as linhas do corpo (sem marcador de comentário ainda)
	local linhas = {"", nome_curto, "Created: " .. hoje, "Updated: " .. hoje}
	for _, l in ipairs(licenca_linhas) do
		table.insert(linhas, l)
	end

	local corpo
	if estilo == "c" then
		local partes = {"/*"}
		for _, l in ipairs(linhas) do
			table.insert(partes, l == "" and "" or ("   " .. l))
		end
		table.insert(partes, "*/")
		corpo = table.concat(partes, "\n")
	else
		local partes = {}
		for _, l in ipairs(linhas) do
			table.insert(partes, l == "" and "#" or ("#  " .. l))
		end
		table.insert(partes, string.rep("#", 78))
		corpo = table.concat(partes, "\n")
	end

	-- coding/shellcheck e os exports de gettext só fazem sentido em
	-- bash/sh — TEXTDOMAIN usa o nome do arquivo sem extensão, pra
	-- funcionar em qualquer script, não só num específico.
	local extra_bash = ""
	if e == "sh" or e == "bash" then
		local dominio = nome_curto:gsub("%.[%w]+$", "")
		extra_bash = "# -*- coding: utf-8 -*-\n" ..
			"# shellcheck shell=bash disable=SC1091,SC2039,SC2166,SC2034\n"
		corpo = corpo .. "\n" ..
			'export LANGUAGE="${LANGUAGE:-pt_BR}"\n' ..
			"export TEXTDOMAINDIR=/usr/share/locale\n" ..
			"export TEXTDOMAIN=" .. dominio
	end

	local primeira_linha_atual = goedit.get_line(0)
	local ja_tem_shebang = primeira_linha_atual:match("^#!") ~= nil
	local shebang_desejado = e and shebang_map[e] or nil

	if ja_tem_shebang then
		-- já tem shebang: não duplica, insere o resto DEPOIS dele —
		-- sem \n final aqui (a linha seguinte original já existe
		-- intocada logo depois do cursor).
		goedit.set_cursor(#primeira_linha_atual, 0)
		local resto = extra_bash .. corpo
		goedit.insert_text("\n" .. resto)
	elseif shebang_desejado then
		goedit.set_cursor(0, 0)
		goedit.insert_text(shebang_desejado .. "\n" .. extra_bash .. corpo .. "\n")
	else
		goedit.set_cursor(0, 0)
		goedit.insert_text(corpo .. "\n")
	end
	goedit.notify("licença completa inserida (estilo " .. estilo .. ")")
end)
