-- Option+G: 选中文字 → 自动复制 → 唤起 Gemini 迷你窗 → 粘贴 → 换行待输入
-- 原理：模拟按下 Gemini 自己的迷你窗全局热键（默认 Option+Space）。

local MINI_HOTKEY_MODS  = {"alt"}     -- Gemini 迷你窗热键的修饰键
local MINI_HOTKEY_KEY   = "space"     -- Gemini 迷你窗热键的主键
local CLIPBOARD_DELAY   = 0.15        -- 等剪贴板写入
local MINI_WINDOW_DELAY = 0.4         -- 等迷你窗弹出+输入框聚焦（不行就调大到 0.6~1.0）

hs.hotkey.bind({"alt"}, "a", function()
  -- 1. 复制当前选中文字
  hs.eventtap.keyStroke({"cmd"}, "c", 0)

  -- 2. 等剪贴板更新
  hs.timer.doAfter(CLIPBOARD_DELAY, function()
    -- 3. 触发 Gemini 的迷你窗全局热键
    hs.eventtap.keyStroke(MINI_HOTKEY_MODS, MINI_HOTKEY_KEY, 0)

    -- 4. 等迷你窗显示并聚焦输入框
    hs.timer.doAfter(MINI_WINDOW_DELAY, function()
      -- 5. 粘贴
      hs.eventtap.keyStroke({"cmd"}, "v", 0)
      -- 6. 换行（Shift+Enter 是 Gemini 的换行键，Enter 会直接发送）
      hs.eventtap.keyStroke({"shift"}, "return", 0)
    end)
  end)
end)

hs.alert.show("Gemini 迷你窗快捷粘贴已加载 (Option+A)")
