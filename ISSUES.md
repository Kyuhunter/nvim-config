# Probleme in der Neovim-Config

Stand: 28. April 2026. Sortiert nach Schweregrad. Verifiziert für Neovim 0.12.x.

---

## 🔴 Kritische Probleme (führen zu Fehlern oder defektem Verhalten)

### ~~2. Redundante Cmdline-Plugins~~ ✅ Kein Problem
**Korrektur:** `mini.cmdline` und `tiny-cmdline` sind **kompatibel** (siehe tiny-cmdline README, Abschnitt „Integrations"). `tiny-cmdline` repositioniert die Cmdline als zentriertes Floating-Window via `vim._core.ui2`, während `mini.cmdline` Autocomplete/Autocorrect/Autopeek bereitstellt. Beide ergänzen sich; kein Fix nötig.

**Hinweis:** `vim._core.ui2` existiert in Neovim 0.12 und muss explizit mit `require("vim._core.ui2").enable({})` aktiviert werden (was in `init.lua` korrekt gemacht wird). Damit ist auch der ehemalige Punkt 1 (`require('vim._core.ui2').enable()`) kein Problem.

---

### ~~4. `lualine.setup` falsch konfiguriert~~ ✅ Gefixt
**Commit:** `🐛 Fix lualine.setup: use direct config instead of lazy.nvim opts pattern`
**Was wurde gemacht:** lazy.nvim `opts`-Pattern durch direkte lualine-Config ersetzt. Trouble-Symbole werden jetzt korrekt als `lualine_c`-Eintrag registriert.

---

### ~~5. `conform.nvim` — `format_on_save` an falscher Stelle~~ ✅ Gefixt
**Commit:** `🐛 Fix conform.nvim: move format_on_save to top-level config`
**Was wurde gemacht:** `format_on_save` aus dem verschachtelten `formatters`-Block auf die Top-Level-Ebene der `setup()`-Tabelle verschoben.

---

### ~~6. `vim.fn.jobstart(vim.cmd(":LspRestart"))` ist Unsinn~~ ✅ Gefixt
**Commit:** `🐛 Fix angularls: replace jobstart(vim.cmd()) with vim.cmd('LspRestart')`
**Was wurde gemacht:** `vim.fn.jobstart(vim.cmd(":LspRestart"))` durch `vim.cmd("LspRestart")` ersetzt.

---

### ~~7. Nicht-jdtls LSP-Server werden nie aktiviert~~ ✅ Gefixt
**Commit:** `🐛 Explicitly enable LSP servers via vim.lsp.enable()`
**Was wurde gemacht:** Explizites `vim.lsp.enable({ "lua_ls", "angularls", "ts_ls", "emmet_language_server", "eslint", "clangd" })` in `plugin/50-lsp.lua` ergänzt.

---

## 🟡 Mittlere Probleme (Funktionalität eingeschränkt)

### ~~8. Tote/leere Config-Dateien~~ ✅ Gefixt
**Commit:** `🔥 Remove empty config files (autocmds, keymaps, diagnostics) and empty config/ dir`
**Was wurde gemacht:** Leere Dateien `lua/config/autocmds.lua`, `lua/config/keymaps.lua`, `lua/config/diagnostics.lua` und das leere Top-Level `config/` Verzeichnis gelöscht.

---

### ~~9. `foldmethod = "expr"` ohne `foldexpr`~~ ✅ Gefixt
**Commit:** `🐛 Fix folding: use opt.foldmethod + add treesitter foldexpr`
**Was wurde gemacht:** `vim.wo.foldmethod` durch `opt.foldmethod = "expr"` ersetzt und `opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"` ergänzt. Funktioniert mit nativen 0.12-Parsern + arborist.

---

### ~~10. `nvim-lint`: `lint.events` Zuweisung wirkungslos~~ ✅ Gefixt
**Commit:** `♻️ Use local variable for lint events instead of polluting lint table`
**Was wurde gemacht:** `lint.events = {...}` durch `local events = {...}` ersetzt; Autocmd nutzt jetzt die lokale Variable.

---

### ~~11. Doppelte Optionen~~ ✅ Gefixt
**Commit:** `🧹 Remove duplicate options (shiftwidth, list)`
**Was wurde gemacht:** Doppelte `opt.shiftwidth = 4` und doppelte `opt.list = false` Zuweisungen entfernt.

---

### 12. JDTLS-Setup ohne projekt-spezifisches `data dir` und `cmd` — ⏳ OFFEN
**Beschreibung:** `plugin/71-jdtls.lua` ruft `vim.lsp.config("jdtls", {...})` und `vim.lsp.enable("jdtls")` global auf. Es fehlen `cmd` (jdtls aus Mason muss explizit angegeben werden), `init_options.workspace`, und vor allem ein **pro-Projekt-`-data` Verzeichnis** (jdtls korrumpiert sonst seinen Workspace-Cache, wenn man zwischen Projekten wechselt).
**Begründung:** jdtls startet u.U. nicht, oder mehrere Java-Projekte teilen sich denselben Workspace-Cache → Indizierungsfehler.

**Warum nicht gefixt:**
Dieser Fix erfordert eine grundsätzliche Architekturentscheidung, die nicht automatisch getroffen werden kann:

1. **Zwei mögliche Wege:** Entweder den generischen `vim.lsp.config()` + `vim.lsp.enable()` Weg beibehalten (einfacher, aber weniger jdtls-Features) oder auf den empfohlenen `nvim-jdtls`-Weg mit `require('jdtls').start_or_attach()` per `FileType java` Autocmd umsteigen (voller Feature-Umfang inkl. Code Actions, Test-Runner, etc.).
2. **Mason-Pfad-Abhängigkeit:** Das `cmd`-Array muss den exakten Pfad zur jdtls-Binary aus Mason enthalten (`vim.fn.expand("$MASON/bin/jdtls")`), und ggf. plattformspezifische Launcher-Argumente.
3. **Projekt-Workspace-Isolation:** Das `-data`-Verzeichnis muss pro Projekt eindeutig sein (z.B. `vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')`), sonst korrumpieren sich Projekte gegenseitig.
4. **Bestehendes `on_attach`:** In `plugin/71-jdtls.lua` ist bereits ein `on_attach` mit DAP-Setup und Test-Keymaps konfiguriert, das beim Umstieg sorgfältig migriert werden muss.

**📋 TODO für dich:**
- Entscheide: `vim.lsp.config`-Weg beibehalten oder auf `require('jdtls').start_or_attach()` umsteigen?
- Falls `start_or_attach`: Das gesamte `plugin/71-jdtls.lua` muss umgeschrieben werden (FileType-Autocmd, cmd-Array, pro-Projekt data-dir, root_dir-Erkennung).
- Falls `vim.lsp.config` beibehalten: Mindestens `cmd` und ein dynamisches `-data`-Verzeichnis ergänzen. Prüfe, ob Mason-jdtls das `cmd` automatisch setzt.
- Teste danach mit mindestens 2 verschiedenen Java-Projekten, ob die Workspace-Caches sauber getrennt sind.

---

### ~~13. DAP-Module unter `lua/dap/`~~ ✅ Gefixt
**Commit:** `🚚 Move DAP modules from lua/dap/ to lua/config/dap/ to avoid nvim-dap collisions` (via Branch `fix/move-dap-modules`)
**Was wurde gemacht:** Alle DAP-Module von `lua/dap/` nach `lua/config/dap/` verschoben. Alle `require("dap.xxx")` in `plugin/70-dap.lua` auf `require("config.dap.xxx")` angepasst.

---

### ~~14. Kein Treesitter installiert~~ ✅ Kein Problem
**Korrektur:** Neovim 0.12 enthält native Treesitter-Parser für C, Lua, Markdown, Vimscript und Vimdoc. Für weitere Sprachen (Java, Python, JavaScript, TypeScript, HTML, CSS, LaTeX etc.) wird `arborist.nvim` verwendet, das bereits in `plugin/05-arborist.lua` installiert ist. `nvim-treesitter` wird nicht benötigt.

---

### 15. `selection = "exclusive"` kann unerwartet stören — ⏳ OFFEN
**Beschreibung:** `lua/config/options.lua` setzt `opt.selection = "exclusive"`. Das ändert das Verhalten von `v`-Visual-Select und vielen Operatoren — z.B. `viw` schließt das letzte Zeichen nicht ein.
**Begründung:** Default `inclusive` ist robuster für Text-Operationen.

**Warum nicht gefixt:**
Dies ist eine persönliche Präferenz, kein klarer Bug:

1. **`exclusive` ist ein valider Wert** — Neovim unterstützt ihn bewusst. Manche User bevorzugen ihn, weil er sich näher am Verhalten anderer Editoren (VS Code, Sublime) anfühlt, wo Selektionen das letzte Zeichen nicht einschließen.
2. **Entfernen könnte Muscle Memory brechen:** Falls du seit längerem mit `exclusive` arbeitest, hast du dich möglicherweise daran gewöhnt. Das Entfernen ändert das Verhalten von `v`, `V`, `<C-v>`, `viw`, `vaw`, `vi"`, `va(` und sämtlichen Visual-Mode-Operationen.
3. **Auswirkung auf Plugins:** `mini.surround`, `mini.comment` und andere Text-Objekt-Plugins verhalten sich je nach `selection`-Wert unterschiedlich. Ein Wechsel erfordert Testen all dieser Workflows.

**📋 TODO für dich:**
- Teste bewusst: Öffne eine Datei, mache `viw` auf einem Wort und prüfe, ob das letzte Zeichen mit-selektiert wird. Ist das das Verhalten, das du willst?
- Falls du `exclusive` behalten willst: Kein Fix nötig — dokumentiere es als bewusste Entscheidung (z.B. Kommentar in `options.lua`).
- Falls du es nicht bewusst gesetzt hast: Entferne die Zeile `opt.selection = "exclusive"` aus `lua/config/options.lua` und teste deine üblichen Visual-Mode-Workflows.

---

## 🟢 Kleinere Probleme / Stilfragen

### ~~16. `vim.g.autoformat = true` und `vim.g.trouble_lualine = true`~~ ✅ Gefixt
**Commit:** `🔥 Remove unused LazyVim globals (vim.g.autoformat, vim.g.trouble_lualine)`
**Was wurde gemacht:** Beide wirkungslosen LazyVim-Globale aus `lua/config/options.lua` entfernt.

---

### ~~17. `undodir = ~/.vim/undodir`~~ ✅ Gefixt
**Commit:** `♻️ Use vim.fn.stdpath('state')/undo instead of ~/.vim/undodir`
**Was wurde gemacht:** Beide Stellen (Option + mkdir-Block) auf `vim.fn.stdpath("state") .. "/undo"` umgestellt.

---

### ~~20. `mini.snippets` ohne Snippet-Loader~~ ✅ Gefixt
**Commit:** `✨ Configure mini.snippets with gen_loader.from_lang() + friendly-snippets`
**Was wurde gemacht:** `friendly-snippets` Plugin hinzugefügt und `mini.snippets` mit `gen_loader.from_lang()` Loader konfiguriert.

---

### ~~21. `dap.providers.configs.jdtls = nil` redundant gesetzt~~ ✅ Gefixt
### ~~22. `M.ensure_adapter()` / `M.ensure_configs()` am Ende von `dap/jdtls.lua`~~ ✅ Gefixt
**Commit:** `🧹 Clean up DAP jdtls: remove redundant discovery disable + startup-time calls`
**Was wurde gemacht:** `disable_jdtls_discovery_provider()` Funktion und alle Aufrufe aus `lua/config/dap/jdtls.lua` entfernt (wird bereits in `plugin/71-jdtls.lua` on_attach erledigt). Die wirkungslosen Startup-Aufrufe `M.ensure_adapter()` / `M.ensure_configs()` am Modulende entfernt.

---

### ~~23. `opt.path:append("**")`~~ ✅ Gefixt
**Commit:** `🔥 Remove opt.path:append('**') — using mini.pick for file finding`
**Was wurde gemacht:** Zeile entfernt.

---

### ~~24. `ttimeoutlen = 0`~~ ✅ Gefixt
**Commit:** `🐛 Set ttimeoutlen=10 instead of 0 to avoid broken escape sequences`
**Was wurde gemacht:** `opt.ttimeoutlen = 0` auf `opt.ttimeoutlen = 10` gesetzt.

---

### ~~25. `which-key` Eintrag in `00-whichkey.lua` falsch geschachtelt~~ ✅ Gefixt
**Commit:** `🐛 Fix which-key spec: use flat desc key instead of nested table`
**Was wurde gemacht:** `{ desc = "..." }` (verschachtelte Tabelle) zu `desc = "..."` (flacher Key) korrigiert.

---

### ~~26. Kein `<leader>`-Key explizit gesetzt~~ ✅ Gefixt
**Commit:** `🔧 Explicitly set mapleader and maplocalleader to space`
**Was wurde gemacht:** `vim.g.mapleader = " "` und `vim.g.maplocalleader = " "` am Anfang von `lua/config/options.lua` ergänzt.
