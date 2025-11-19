---@diagnostic disable: undefined-global

local buf = vim.api.nvim_get_current_buf()
local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")

if filename ~= "build.gradle.kts" then
    return
end

local plugin_line = 'id("org.openrewrite.rewrite") version("latest.release")'
local recipe_line = 'activeRecipe("com.yourorg.AddLicenseHeaderExample")'
local export_line = "setExportDatatables(true)"

local function find_block(lines, pattern)
    for idx, line in ipairs(lines) do
        if line:match(pattern) then
            local depth = 0
            for inner = idx, #lines do
                local current = lines[inner]
                local opens = select(2, current:gsub("%{", ""))
                local closes = select(2, current:gsub("%}", ""))
                depth = depth + opens - closes
                if depth == 0 then
                    return idx, inner
                end
            end
            break
        end
    end
end

local function ensure_plugins(lines)
    local start_idx, end_idx = find_block(lines, "^%s*plugins%s*{")
    if not start_idx then
        table.insert(lines, 1, "plugins {")
        table.insert(lines, 2, "    " .. plugin_line)
        table.insert(lines, 3, "}")
        table.insert(lines, 4, "")
        return true
    end

    for i = start_idx, end_idx do
        if lines[i]:find("org.openrewrite.rewrite", 1, true) then
            return false
        end
    end

    local indent = (lines[start_idx]:match("^(%s*)") or "") .. "    "
    table.insert(lines, end_idx, indent .. plugin_line)
    return true
end

local function ensure_rewrite_block(lines)
    local start_idx, end_idx = find_block(lines, "^%s*rewrite%s*{")
    if not start_idx then
        if #lines > 0 and lines[#lines]:match("%S") then
            table.insert(lines, "")
        end
        table.insert(lines, "rewrite {")
        table.insert(lines, "    " .. recipe_line)
        table.insert(lines, "    " .. export_line)
        table.insert(lines, "}")
        return true
    end

    local changed = false
    local indent = (lines[start_idx]:match("^(%s*)") or "") .. "    "
    local has_recipe, has_export = false, false

    for i = start_idx, end_idx do
        if lines[i]:find(recipe_line, 1, true) then
            has_recipe = true
        end
        if lines[i]:find(export_line, 1, true) then
            has_export = true
        end
    end

    if not has_recipe then
        table.insert(lines, end_idx, indent .. recipe_line)
        end_idx = end_idx + 1
        changed = true
    end

    if not has_export then
        table.insert(lines, end_idx, indent .. export_line)
        changed = true
    end

    return changed
end

vim.api.nvim_buf_create_user_command(buf, "GradleRewriteSetup", function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local plugin_changed = ensure_plugins(lines)
    local rewrite_changed = ensure_rewrite_block(lines)

    if not plugin_changed and not rewrite_changed then
        vim.notify("Rewrite plugin and block already configured", vim.log.levels.INFO)
        return
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.notify("Added OpenRewrite plugin and configuration", vim.log.levels.INFO)
end, {
    desc = "Ensure Gradle Kotlin DSL rewrite plugin and config are present"
})
