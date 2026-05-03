-- Option+Shift+G: 区域截图 → 自动粘贴到 Gemini 迷你窗 → 换行待输入
-- 原理：触发 macOS 自带的「区域截图到剪贴板」(Cmd+Ctrl+Shift+4)，
-- 然后轮询剪贴板，一旦检测到截图就唤起 Gemini 迷你窗并粘贴。

local MINI_HOTKEY_MODS  = {"alt"}     -- Gemini 迷你窗的修饰键
local MINI_HOTKEY_KEY   = "space"     -- Gemini 迷你窗的主键
local POLL_INTERVAL     = 0.2         -- 多久检查一次剪贴板
local TIMEOUT_SECONDS   = 30          -- 超过这么久没截图就放弃
local MINI_WINDOW_DELAY = 0.5         -- 迷你窗弹出+输入框聚焦的等待时间
local POST_SHOT_DELAY   = 0.1         -- 截图完成后稍等一下再唤起 Gemini

hs.hotkey.bind({"alt", "shift"}, "a", function()
  local startCount = hs.pasteboard.changeCount()

  -- 1. 触发系统区域截图到剪贴板
  hs.eventtap.keyStroke({"cmd", "ctrl", "shift"}, "4", 0)

  -- 2. 轮询等待截图完成
  local elapsed = 0
  local timer
  timer = hs.timer.doEvery(POLL_INTERVAL, function()
    elapsed = elapsed + POLL_INTERVAL

    if hs.pasteboard.changeCount() ~= startCount then
      timer:stop()
      -- 确认剪贴板里是图片（避免误触发）
      if hs.pasteboard.readImage() then
        hs.timer.doAfter(POST_SHOT_DELAY, function()
          -- 3. 唤起 Gemini 迷你窗
          hs.eventtap.keyStroke(MINI_HOTKEY_MODS, MINI_HOTKEY_KEY, 0)
          -- 4. 等输入框聚焦
          hs.timer.doAfter(MINI_WINDOW_DELAY, function()
            -- 5. 粘贴截图（图片粘贴后光标已经在下一行，不需要再 Shift+Enter）
            hs.eventtap.keyStroke({"cmd"}, "v", 0)
          end)
        end)
      end
    elseif elapsed >= TIMEOUT_SECONDS then
      -- 用户按 Esc 取消、或一直没截图，放弃
      timer:stop()
    end
  end)
end)

hs.alert.show("Gemini 截图粘贴已加载 (Option+Shift+A)")
