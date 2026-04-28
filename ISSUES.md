# Probleme in der Neovim-Config

Stand: 28. April 2026. Sortiert nach Schweregrad. Verifiziert für Neovim 0.12.x.

---

## 🔴 Kritische Probleme (führen zu Fehlern oder defektem Verhalten)

### ~~2. Redundante Cmdline-Plugins~~ ✅ Kein Problem
**Korrektur:** `mini.cmdline` und `tiny-cmdline` sind **kompatibel** (siehe tiny-cmdline README, Abschnitt „Integrations"). `tiny-cmdline` repositioniert die Cmdline als zentriertes Floating-Window via `vim._core.ui2`, während `mini.cmdline` Autocomplete/Autocorrect/Autopeek bereitstellt. Beide ergänzen sich; kein Fix nötig.

**Hinweis:** `vim._core.ui2` existiert in Neovim 0.12 und muss explizit mit `require("vim._core.ui2").enable({})` aktiviert werden (was in `init.lua` korrekt gemacht wird). Damit ist auch der ehemalige Punkt 1 (`require('vim._core.ui2').enable()`) kein Problem.

---

### 4. `lualine.setup` falsch konfiguriert
**Beschreibung:** `plugin/99-lualine.lua` ruft `require("lualine").setup({ opts = { function(_, opts) ... end } })` auf. Das `{ opts = function(...) }` Format ist ein **lazy.nvim**-Pattern, nicht das von lualine. Lualine erwartet die Konfiguration direkt als Tabelle (mit `sections`, `options`, etc.).
**Begründung:** Die Trouble-Symbol-Integration in der Statuszeile passiert nie; lualine startet mit Defaults.
**Fix-Vorschlag:** Konfig flach schreiben — Trouble-Symbole als zusätzlichen `lualine_c` Eintrag.
**Anleitung für KI-Agent:** In `plugin/99-lualine.lua`: Setze die `symbols` außerhalb von `setup`, dann `require("lualine").setup({ sections = { lualine_c = { 'filename', { symbols.get, cond = symbols.has } } } })`. Siehe folke/trouble.nvim README → Statusline als Referenz.

---

### 5. `conform.nvim` — `format_on_save` an falscher Stelle
**Beschreibung:** In `plugin/55-format.lua` ist `format_on_save = { ... }` **innerhalb von `formatters = { luaformat = { ... }, format_on_save = ... }`** verschachtelt. Conform erwartet `format_on_save` auf Top-Level der Setup-Tabelle.
**Begründung:** Auto-Format beim Speichern funktioniert nicht; conform interpretiert es als (kaputte) Formatter-Definition.
**Fix-Vorschlag:** `format_on_save` aus `formatters` herausziehen, eine Ebene nach oben in das `setup({...})` Argument.
**Anleitung für KI-Agent:** In `plugin/55-format.lua`: Entferne `format_on_save = ...` aus dem `formatters`-Tabellen-Body und füge es als geschwisterlichen Schlüssel zu `formatters_by_ft` und `formatters` hinzu. Format: `format_on_save = function(bufnr) return { timeout_ms = 500, lsp_format = "fallback" } end`.

---

### 6. `vim.fn.jobstart(vim.cmd(":LspRestart"))` ist Unsinn
**Beschreibung:** In `lsp/angularls.lua` wird `vim.cmd(":LspRestart")` direkt synchron ausgeführt und gibt `nil` zurück; `jobstart(nil)` ist sinnlos.
**Begründung:** Doppelte Ausführung / falsche Semantik. `vim.defer_fn` reicht nicht aus, um sicherzustellen, dass `npm install` fertig ist (nutzt blockierendes `vim.fn.system`, also fertig — aber dann ist `jobstart(nil)` trotzdem falsch).
**Fix-Vorschlag:** Nur `vim.cmd("LspRestart")` ohne `jobstart`. Optional `vim.fn.system` durch async `vim.system()` ersetzen.
**Anleitung für KI-Agent:** In `lsp/angularls.lua` ersetze `vim.fn.jobstart(vim.cmd(":LspRestart"))` mit `vim.cmd("LspRestart")`. Optional: blockierendes `vim.fn.system` durch `vim.system({...}, { text = true }, on_exit)` async-ifizieren.

---

### 7. Nicht-jdtls LSP-Server werden nie aktiviert
**Beschreibung:** Die LSP-Configs in `lsp/` (`angularls.lua`, `clangd.lua`, `emmet_language_server.lua`) werden nirgendwo via `vim.lsp.enable(...)` aktiviert. Nur jdtls wird in `plugin/71-jdtls.lua` explizit enabled. `mason-lspconfig.automatic_enable` mit nur `exclude` aktiviert installierte Server — aber zu verifizieren, ob dies wirklich für die in `lsp/` deklarierten Server greift.
**Begründung:** Verifizieren ob automatic_enable die Server tatsächlich startet — sonst funktionieren die `lsp/*.lua` Files nie.
**Fix-Vorschlag:** Explizit `vim.lsp.enable({ "clangd", "angularls", "emmet_language_server", "ts_ls", "eslint", "lua_ls" })` in einer zentralen Stelle setzen.
**Anleitung für KI-Agent:** Prüfe mit dem User per `:LspInfo` welche Server tatsächlich laufen. Falls nicht: Füge in `plugin/50-lsp.lua` nach den Mason-Setups `vim.lsp.enable({...})` mit allen gewünschten Servern hinzu.

---

## 🟡 Mittlere Probleme (Funktionalität eingeschränkt)

### 8. Tote/leere Config-Dateien
**Beschreibung:** `lua/config/autocmds.lua`, `lua/config/keymaps.lua`, `lua/config/diagnostics.lua` sind leer. `lua/config/init.lua` lädt nur `config.options`. Auch das Top-Level `config/` Verzeichnis ist leer.
**Begründung:** Verwirrt beim Lesen; suggeriert Funktionalität, die nicht existiert.
**Fix-Vorschlag:** Entweder befüllen oder löschen. `config/` (top-level) löschen.
**Anleitung für KI-Agent:** Frage den User, ob die Files gelöscht oder befüllt werden sollen. Wenn löschen: `rm` mit Bestätigung. Wenn behalten: in `lua/config/init.lua` ergänzen: `require("config.autocmds"); require("config.keymaps"); require("config.diagnostics")`.

---

### 9. `foldmethod = "expr"` ohne `foldexpr`
**Beschreibung:** `lua/config/options.lua` setzt `vim.wo.foldmethod = "expr"`, aber kein `foldexpr` (z.B. `vim.treesitter.foldexpr()`). Außerdem ist `vim.wo` window-lokal und gilt nur für das aktuelle Fenster beim Start.
**Begründung:** Folding funktioniert nicht oder unvorhersehbar. `vim.wo` setzt nicht den Default für künftige Fenster.
**Fix-Vorschlag:** `vim.opt.foldmethod = "expr"` und `vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"`. Neovim 0.12 hat native Treesitter-Parser für C, Lua, Markdown, Vimscript und Vimdoc eingebaut — `foldexpr` funktioniert damit sofort. Für weitere Sprachen liefert `arborist.nvim` (bereits in `plugin/05-arborist.lua`) Parser nach.
**Anleitung für KI-Agent:** In `lua/config/options.lua` `vim.wo.foldmethod` durch `opt.foldmethod = "expr"` ersetzen und `opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"` ergänzen. Kein zusätzliches Plugin nötig (native Parser + arborist reichen).

---

### 10. `nvim-lint`: `lint.events` Zuweisung wirkungslos
**Beschreibung:** `plugin/56-lint.lua` setzt `lint.events = {...}`. Dieses Feld existiert in nvim-lint nicht; die Liste wird aber später korrekt im Autocmd verwendet. Verwirrend, aber harmlos, **außer** dass die Zuweisung `lint.events` als globalen Tabellen-Feld setzt, das nichts steuert.
**Begründung:** Cosmetic / Maintenance-Falle — sieht aus wie Plugin-Konfig, ist aber nur eine lokale Variable.
**Fix-Vorschlag:** Lokale Variable nutzen: `local events = { "BufWritePost", ... }`.
**Anleitung für KI-Agent:** In `plugin/56-lint.lua`: Ersetze `lint.events =` mit `local events =` und passe die `nvim_create_autocmd` Zeile an (`autocmd(events, ...)`).

---

### 11. Doppelte Optionen
**Beschreibung:** In `lua/config/options.lua` wird `opt.shiftwidth = 4` zweimal gesetzt (einmal früh, einmal weiter unten) und `opt.list = false` zweimal hintereinander.
**Begründung:** Code-Lärm, keine funktionale Auswirkung.
**Fix-Vorschlag:** Duplikate entfernen.
**Anleitung für KI-Agent:** Eine der Zuweisungen jeweils löschen. Behalten: die ausführlichere/kommentierte Version.

---

### 12. JDTLS-Setup ohne projekt-spezifisches `data dir` und `cmd`
**Beschreibung:** `plugin/71-jdtls.lua` ruft `vim.lsp.config("jdtls", {...})` und `vim.lsp.enable("jdtls")` global auf. Es fehlen `cmd` (jdtls aus Mason muss explizit angegeben werden), `init_options.workspace`, und vor allem ein **pro-Projekt-`-data` Verzeichnis** (jdtls korrumpiert sonst seinen Workspace-Cache, wenn man zwischen Projekten wechselt).
**Begründung:** jdtls startet u.U. nicht, oder mehrere Java-Projekte teilen sich denselben Workspace-Cache → Indizierungsfehler.
**Fix-Vorschlag:** Empfohlene Variante: `nvim-jdtls` `start_or_attach` per FileType-Autocmd nutzen — nicht den generischen lspconfig-Weg. Pro-Projekt `-data` aus Hash des Root-Dirs.
**Anleitung für KI-Agent:** Lies die nvim-jdtls README. Ersetze in `plugin/71-jdtls.lua` `vim.lsp.config/enable` durch einen `FileType java` Autocmd, der `require('jdtls').start_or_attach({ cmd = {...}, root_dir = ..., data = vim.fn.stdpath('cache') .. '/jdtls/' .. project_name, ...})` ausführt. Frage den User vorher, ob er den lspconfig- oder den nvim-jdtls-Weg bevorzugt.

---

### 13. DAP-Module unter `lua/dap/` (siehe Repo-Memo)
**Beschreibung:** `lua/dap/jdtls.lua`, `lua/dap/clang.lua`, etc. liegen im Modul-Pfad `dap.*`. Laut Repo-Memo `nvim-dap-module-collisions.md` kollidiert das mit nvim-dap internen Modulen. Die aktuellen Namen (`dap.jdtls`, `dap.clang`, `dap.debugpy`) kollidieren zwar nicht mit echten internen Modulen — aber das Risiko bleibt bestehen.
**Begründung:** Vorbeugung; bereits einmal gebrannt mit `dap.ui`.
**Fix-Vorschlag:** Module nach `lua/config/dap/` (oder `lua/myconfig/dap/`) verschieben.
**Anleitung für KI-Agent:** Verschiebe alle Files aus `lua/dap/` nach `lua/config/dap/`. Passe alle `require("dap.xxx")` in `plugin/70-dap.lua` auf `require("config.dap.xxx")` an. Aktualisiere danach das Repo-Memo.

---

### ~~14. Kein Treesitter installiert~~ ✅ Kein Problem
**Korrektur:** Neovim 0.12 enthält native Treesitter-Parser für C, Lua, Markdown, Vimscript und Vimdoc. Für weitere Sprachen (Java, Python, JavaScript, TypeScript, HTML, CSS, LaTeX etc.) wird `arborist.nvim` verwendet, das bereits in `plugin/05-arborist.lua` installiert ist. `nvim-treesitter` wird nicht benötigt.

---

### 15. `selection = "exclusive"` kann unerwartet stören
**Beschreibung:** `lua/config/options.lua` setzt `opt.selection = "exclusive"`. Das ändert das Verhalten von `v`-Visual-Select und vielen Operatoren — z.B. `viw` schließt das letzte Zeichen nicht ein.
**Begründung:** Default `inclusive` ist robuster für Text-Operationen.
**Fix-Vorschlag:** Auf Default lassen (entfernen) oder bewusst dokumentieren.
**Anleitung für KI-Agent:** Frage den User, ob das beabsichtigt ist. Wenn nicht: Zeile löschen.

---

## 🟢 Kleinere Probleme / Stilfragen

### 16. `vim.g.autoformat = true` und `vim.g.trouble_lualine = true`
**Beschreibung:** `lua/config/options.lua` setzt zwei LazyVim-spezifische Globale. Die Config nutzt aber kein LazyVim → wirkungslos.
**Fix-Vorschlag:** Entfernen.
**Anleitung für KI-Agent:** Beide Zeilen aus `lua/config/options.lua` löschen.

---

### 17. `undodir = ~/.vim/undodir`
**Beschreibung:** Vim-Pfad statt Neovim-stdpath. Funktioniert, aber unsauber.
**Fix-Vorschlag:** `vim.fn.stdpath("state") .. "/undo"`.
**Anleitung für KI-Agent:** In `lua/config/options.lua` `~/.vim/undodir` durch `vim.fn.stdpath("state") .. "/undo"` ersetzen, an beiden Stellen (Zuweisung + mkdir).

---

### 20. `mini.snippets` ohne Snippet-Loader
**Beschreibung:** `plugin/02-mini.lua` ruft `require("mini.snippets").setup({})` auf, lädt aber keine Snippets (z.B. via `gen_loader.from_lang()`).
**Fix-Vorschlag:** Loader konfigurieren oder Setup entfernen.
**Anleitung für KI-Agent:** Wenn Snippets gewünscht: `local gen_loader = require("mini.snippets").gen_loader; require("mini.snippets").setup({ snippets = { gen_loader.from_file(...), gen_loader.from_lang() } })`. Sonst Zeile entfernen.

---

### 21. `dap.providers.configs.jdtls = nil` redundant gesetzt
**Beschreibung:** Sowohl in `lua/dap/jdtls.lua` als auch in `plugin/71-jdtls.lua` wird die jdtls-DAP-Discovery deaktiviert.
**Fix-Vorschlag:** Auf eine Stelle reduzieren.
**Anleitung für KI-Agent:** In `lua/dap/jdtls.lua` die Funktion `disable_jdtls_discovery_provider()` und ihre Aufrufe entfernen, da `plugin/71-jdtls.lua` das beim `on_attach` schon erledigt.

---

### 22. `M.ensure_adapter()` / `M.ensure_configs()` am Ende von `dap/jdtls.lua` werden zur Startzeit ausgeführt
**Beschreibung:** `lua/dap/jdtls.lua` ruft `ensure_adapter`/`ensure_configs` direkt beim `require`. Da dies in `plugin/70-dap.lua` am Startup passiert, läuft es bevor jdtls je gestartet wurde — also wirkungslos. Außerdem: doppelte Logik mit dem `dap_continue` Wrapper.
**Fix-Vorschlag:** Direkten Aufruf am Modulende entfernen; nur durch `dap_continue` triggern.
**Anleitung für KI-Agent:** In `lua/dap/jdtls.lua` die letzten zwei Zeilen `M.ensure_adapter()` und `M.ensure_configs()` (vor `return M`) löschen.

---

### 23. `opt.path:append("**")`
**Beschreibung:** Macht `:find` rekursiv aber kann in großen Repos langsam werden.
**Fix-Vorschlag:** Da `mini.pick` und Telescope-artige Tools genutzt werden, `**` nicht nötig.
**Anleitung für KI-Agent:** Zeile in `lua/config/options.lua` entfernen, wenn der User `mini.pick` für File-Finding nutzt.

---

### 24. `ttimeoutlen = 0`
**Beschreibung:** Kann auf manchen Terminals (insbesondere SSH/tmux) Escape-Sequenzen brechen — z.B. Funktionstasten oder Maus-Codes können fehlschlagen.
**Fix-Vorschlag:** Default (`50`) lassen oder explizit `10` setzen.
**Anleitung für KI-Agent:** In `lua/config/options.lua` `opt.ttimeoutlen = 0` entfernen oder auf `10` setzen.

---

### 25. `which-key` Eintrag in `00-whichkey.lua` falsch geschachtelt
**Beschreibung:** In `plugin/00-whichkey.lua` ist `{ desc = "..." }` als drittes Element der Spec-Tabelle übergeben. Korrekte Syntax: `desc` direkt als Key, nicht in einer extra Tabelle.
**Fix-Vorschlag:** `{ desc = "..." }` zu `desc = "..."` umschreiben.
**Anleitung für KI-Agent:** In `plugin/00-whichkey.lua` ersetze `{ desc = "Buffer Local Keymaps (which-key)" }` durch `desc = "Buffer Local Keymaps (which-key)"` direkt im umgebenden Spec.

---

### 26. Kein `<leader>`-Key explizit gesetzt
**Beschreibung:** Es wird auf Space-Leader gesetzt (`mini.basics` setzt das), aber nicht explizit. Falls `mini.basics` mal entfernt wird, fallen alle `<leader>...` Keymaps auf `\` zurück.
**Fix-Vorschlag:** `vim.g.mapleader = " "` und `vim.g.maplocalleader = " "` früh in `lua/config/options.lua` (oder vor `init.lua`-Plugin-Lade) setzen.
**Anleitung für KI-Agent:** Am Anfang von `lua/config/options.lua` zwei Zeilen ergänzen: `vim.g.mapleader = " "` und `vim.g.maplocalleader = " "`.
