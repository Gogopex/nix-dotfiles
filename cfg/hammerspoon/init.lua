-- app switching with hyper+number (shift+ctrl+alt+cmd)
local apps = {
  { key = "1", app = "Ghostty" },
  { key = "2", app = "Arc" },
  { key = "3", app = "Obsidian" },
  { key = "4", app = "Sublime Text" },
  { key = "5", app = "ChatGPT" },
}

for _, binding in ipairs(apps) do
  hs.hotkey.bind({"shift", "ctrl", "alt", "cmd"}, binding.key, function()
    hs.application.launchOrFocus(binding.app)
  end)
end

-- reload config automatically when this file changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("hammerspoon config loaded") 
