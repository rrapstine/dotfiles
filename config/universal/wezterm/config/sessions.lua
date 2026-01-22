local wezterm

local M = {}

function M.setup(wez)
  wezterm = wez
end

local function scan_projects()
  local projects = {}
  local home = wezterm.home_dir

  local projects_dir = home .. '/Code/projects'
  local success, entries = pcall(wezterm.read_dir, projects_dir)
  if success then
    for _, entry in ipairs(entries) do
      local git_dir = entry .. '/.git'
      local git_check = io.open(git_dir, 'r')
      if git_check then
        git_check:close()
        local name = entry:match('([^/]+)$')
        table.insert(projects, { name = name, path = entry })
      end
    end
  end

  local dotfiles = home .. '/Code/dotfiles'
  local git_check = io.open(dotfiles .. '/.git', 'r')
  if git_check then
    git_check:close()
    table.insert(projects, { name = 'dotfiles', path = dotfiles })
  end

  table.sort(projects, function(a, b) return a.name < b.name end)

  return projects
end

local function create_workspace(window, name, path)
  local mux_window = window:mux_window()

  local mux = wezterm.mux

  local new_window = mux_window:spawn_tab({
    workspace = name,
    cwd = path,
    args = { 'nvim' },
  })

  for _, w in ipairs(mux.all_windows()) do
    if w:get_workspace() == name then
      new_window = w
      break
    end
  end

  new_window:spawn_tab({
    cwd = path,
    args = { 'opencode' },
  })

  new_window:spawn_tab({
    cwd = path,
  })

  new_window:tabs()[1]:activate()

  mux.set_active_workspace(name)
end

function M.show_project_picker(window, pane)
  local projects = scan_projects()
  local choices = {}

  for _, project in ipairs(projects) do
    table.insert(choices, {
      id = project.path,
      label = project.name,
    })
  end

  window:perform_action(
    wezterm.action.InputSelector({
      title = 'Select Project',
      choices = choices,
      fuzzy = true,
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if not id then return end

        local workspaces = wezterm.mux.get_workspace_names()
        local exists = false
        for _, ws in ipairs(workspaces) do
          if ws == label then
            exists = true
            break
          end
        end

        if exists then
          inner_window:perform_action(
            wezterm.action.SwitchToWorkspace({ name = label }),
            inner_pane
          )
        else
          create_workspace(inner_window, label, id)
        end
      end),
    }),
    pane
  )
end

function M.show_workspace_switcher(window, pane)
  local workspaces = wezterm.mux.get_workspace_names()
  local choices = {}

  for _, name in ipairs(workspaces) do
    table.insert(choices, {
      id = name,
      label = name,
    })
  end

  window:perform_action(
    wezterm.action.InputSelector({
      title = 'Switch Workspace',
      choices = choices,
      fuzzy = true,
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if not id then return end
        inner_window:perform_action(
          wezterm.action.SwitchToWorkspace({ name = id }),
          inner_pane
        )
      end),
    }),
    pane
  )
end

return M
