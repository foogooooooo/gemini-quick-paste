# Gemini 一键粘贴热键（Mac）

为 Mac 上的 Google Gemini 桌面应用提供三个全局热键，把「选中 → 复制 → 切换 App → 粘贴 → 提问」缩减成一键。

| 热键 | 行为 |
| --- | --- |
| **Option + V** | 选中文字 → 自动复制 → 打开 Gemini **主窗** → 粘贴 → 光标在新一行待输入 |
| **Option + G** | 选中文字 → 自动复制 → 唤起 Gemini **迷你窗** → 粘贴 → 光标在新一行待输入 |
| **Option + Shift + G** | **区域截图** → 截图自动粘贴到 Gemini **迷你窗** 等你输入 |

> 截图热键的工作流：按下后系统进入截图模式（鼠标变十字），框选区域 → 松手 → Gemini 迷你窗自动弹出，截图已经粘进输入框。按 Esc 可以取消截图。
>
> 截图版不会再额外按一次 Shift+Enter——图片粘贴后光标本来就在图片下面一行，不需要多空一行。

---

## 安装步骤（一次性，约 3 分钟）

### 1. 安装 Hammerspoon
打开「终端 (Terminal)」执行：

```bash
brew install --cask hammerspoon
```

> 没装 Homebrew 也可以去 https://www.hammerspoon.org 下载 zip，把 Hammerspoon.app 拖到「应用程序」。

### 2. 启动并授权
- 打开 Hammerspoon.app（菜单栏会出现一个小锤子图标 🔨）。
- 系统会弹窗要求「辅助功能」权限。如果没弹：
  **系统设置 → 隐私与安全性 → 辅助功能 → 打开 Hammerspoon 的开关**。
- 截图热键还需要「屏幕录制」权限：
  **系统设置 → 隐私与安全性 → 屏幕录制 → 打开 Hammerspoon 的开关**（首次按 Option+Shift+G 时系统会自动弹窗提示）。

### 3. 加载脚本
克隆本仓库后执行：

```bash
git clone https://github.com/foogooooooo/gemini-quick-paste.git
cd gemini-quick-paste
mkdir -p ~/.hammerspoon
cat gemini-paste.lua gemini-mini-paste.lua gemini-screenshot-paste.lua >> ~/.hammerspoon/init.lua
```

然后点菜单栏的 🔨 图标 → **Reload Config**。屏幕中央会依次闪三条提示：
- 「Gemini 快捷粘贴已加载 (Option+V)」
- 「Gemini 迷你窗快捷粘贴已加载 (Option+G)」
- 「Gemini 截图粘贴已加载 (Option+Shift+G)」

只想用其中一两个？把不需要的那几个 `cat` 参数去掉就行。

---

## 前置条件
- macOS（已在 Apple Silicon 上验证）
- 已安装 Google 官方 [Gemini Mac 桌面应用](https://gemini.google.com/app)
- Gemini 迷你窗的全局热键设为 **Option+Space**（应用默认值；如果你改过，把脚本里 `MINI_HOTKEY_MODS` / `MINI_HOTKEY_KEY` 改成你的设置）

---

## 文件说明
- [`gemini-paste.lua`](./gemini-paste.lua) — Option+V，主窗口版
- [`gemini-mini-paste.lua`](./gemini-mini-paste.lua) — Option+G，迷你窗版
- [`gemini-screenshot-paste.lua`](./gemini-screenshot-paste.lua) — Option+Shift+G，截图版

---

## 故障排查

### 按了没反应
- 确认菜单栏有 Hammerspoon 的 🔨 图标，并且「辅助功能」开关已打开。
- 点 🔨 → Console，看有没有红色错误。

### Gemini 主窗没打开（Option+V）
默认用应用名 `"Gemini"` 启动。如果你的 Gemini.app 不是这个名字，查 Bundle ID：

```bash
osascript -e 'id of app "Gemini"'
```

把 `gemini-paste.lua` 中那两行的注释互换：

```lua
-- hs.application.launchOrFocus(GEMINI_APP_NAME)
hs.application.launchOrFocusBundleID("com.google.Gemini")  -- 换成你查到的 ID
```

### 迷你窗没出来（Option+G / Option+Shift+G）
脚本是通过模拟「Gemini 自己的迷你窗热键」来唤起的，默认假设是 **Option+Space**。如果你在 Gemini 设置里改过，把脚本里这两行改成你的设置：

```lua
local MINI_HOTKEY_MODS  = {"alt"}     -- 例如 {"cmd","shift"}
local MINI_HOTKEY_KEY   = "space"     -- 例如 "g"
```

### 粘贴时机不对（粘到了原应用 / 没粘上）
Gemini 还没准备好就粘了。把对应脚本里的延迟参数调大：
- `gemini-paste.lua` → `FOCUS_DELAY` 从 `0.4` 调到 `0.8~1.0`
- `gemini-mini-paste.lua` → `MINI_WINDOW_DELAY` 从 `0.4` 调到 `0.7`
- `gemini-screenshot-paste.lua` → `MINI_WINDOW_DELAY` 从 `0.5` 调到 `0.8`

### 截图后没反应
- 检查 Hammerspoon 是否有「屏幕录制」权限。
- 系统区域截图到剪贴板的快捷键是 `Cmd+Ctrl+Shift+4`，确认你没在系统设置里改掉它。

### Shift+Enter 把消息直接发送了
说明你那个版本的 Gemini 换行键不是 Shift+Enter。把脚本里这行：

```lua
hs.eventtap.keyStroke({"shift"}, "return", 0)
```

改成：

```lua
hs.eventtap.keyStroke({}, "return", 0)        -- 试试普通 Enter
-- 或者干脆删掉这一行
```

### 想换其它热键
每个脚本第一行都是 `hs.hotkey.bind({"alt"}, "v", ...)`，把修饰键和主键换成你想要的即可，改完 Reload Config。

---

## 卸载
打开 `~/.hammerspoon/init.lua`，把每段以 `-- Option+...` 开头、到对应 `hs.alert.show(...)` 结束的整段删掉，Reload Config 即可。要完全卸载 Hammerspoon 就把它拖进废纸篓。

---

## License
MIT
