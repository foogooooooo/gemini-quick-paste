-- Option+V: 选中文字 → 自动复制 → 唤起 Gemini → 粘贴 → 换行待输入
-- 把这段代码整段粘到 ~/.hammerspoon/init.lua 末尾即可。

local GEMINI_APP_NAME = "Gemini"      -- 若不生效，改成 Bundle ID 那一行（见下方注释）
local CLIPBOARD_DELAY = 0.15          -- 等剪贴板写入完成
local FOCUS_DELAY     = 0.4           -- 等 Gemini 输入框聚焦（冷启动可调大到 0.8~1.2）

hs.hotkey.bind({"alt"}, "v", function()
  -- 1. 在当前前台 App 复制选中文字
  hs.eventtap.keyStroke({"cmd"}, "c", 0)

  -- 2. 等剪贴板更新
  hs.timer.doAfter(CLIPBOARD_DELAY, function()
    -- 3. 唤起 Gemini（如果用名字打不开，注释下一行，启用再下一行）
    hs.application.launchOrFocus(GEMINI_APP_NAME)
    -- hs.application.launchOrFocusBundleID("com.google.Gemini")

    -- 4. 等输入框聚焦
    hs.timer.doAfter(FOCUS_DELAY, function()
      -- 5. 粘贴
      hs.eventtap.keyStroke({"cmd"}, "v", 0)
      -- 6. 换行（Gemini 中 Enter 会直接发送，Shift+Enter 才是换行）
      hs.eventtap.keyStroke({"shift"}, "return", 0)
    end)
  end)
end)

hs.alert.show("Gemini 快捷粘贴已加载 (Option+V)")
