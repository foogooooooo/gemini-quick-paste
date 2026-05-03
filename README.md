# Gemini 一键粘贴热键（Option+V）

选中任何应用里的文字 → 按一次 **Option+V** → Gemini 自动打开、文字自动粘贴、光标自动换行，立刻可以接着写你的问题。

---

## 安装步骤（一次性，约 3 分钟）

### 1. 安装 Hammerspoon
打开「终端 (Terminal)」执行：

```bash
brew install --cask hammerspoon
```

> 没装 Homebrew 的话，也可以直接去 https://www.hammerspoon.org 下载 zip，把 Hammerspoon.app 拖到「应用程序」即可。

### 2. 启动并授权
- 打开 Hammerspoon.app（菜单栏会出现一个小锤子图标 🔨）。
- 系统会弹窗要求「辅助功能」权限。如果没弹，自己去：
  **系统设置 → 隐私与安全性 → 辅助功能 → 打开 Hammerspoon 的开关**。

### 3. 加载脚本
执行下面这一行，把脚本追加到 Hammerspoon 配置：

```bash
mkdir -p ~/.hammerspoon && cat "/Users/jeremy/Desktop/gemini桌面应用插件/gemini-paste.lua" >> ~/.hammerspoon/init.lua
```

然后点菜单栏的 🔨 图标 → **Reload Config**。屏幕中央会闪一下「Gemini 快捷粘贴已加载 (Option+V)」就说明成功了。

---

## 使用方式
1. 在任何应用（浏览器、VS Code、PDF、微信、终端…）里选中一段文字。
2. 按 **Option + V**。
3. Gemini 自动弹出，文字已经在输入框里，光标停在第二行——直接打字描述你的问题，回车发送。

> 不选文字直接按 Option+V 也行，会粘贴你当前剪贴板里的内容。

---

## 故障排查

### 按了没反应
- 确认菜单栏有 Hammerspoon 的 🔨 图标，并且「辅助功能」里它的开关是开的。
- 点 🔨 → Console，看有没有红色错误信息。

### Gemini 没打开
脚本里默认用应用名 `"Gemini"` 启动。如果你的 Gemini.app 不是这个名字，先在终端查 Bundle ID：

```bash
osascript -e 'id of app "Gemini"'
```

把得到的 ID（比如 `com.google.Gemini`）填到 `gemini-paste.lua` 里——把这两行的注释互换一下：

```lua
-- hs.application.launchOrFocus(GEMINI_APP_NAME)
hs.application.launchOrFocusBundleID("com.google.Gemini")  -- 换成你查到的 ID
```

然后 Reload Config。

### 粘贴时机不对（粘到了原应用 / 没粘上）
说明 Gemini 还没准备好就粘了。把 `gemini-paste.lua` 里的 `FOCUS_DELAY` 从 `0.4` 调大，比如 `0.8` 或 `1.0`，再 Reload。

### Shift+Enter 把消息直接发送了
说明你那个版本的 Gemini 换行键不是 Shift+Enter。把脚本里那行：

```lua
hs.eventtap.keyStroke({"shift"}, "return", 0)
```

改成：

```lua
hs.eventtap.keyStroke({}, "return", 0)        -- 试试普通 Enter
-- 或者干脆删掉这一行，让光标停在粘贴文本末尾
```

### 想换个热键
脚本第一行：

```lua
hs.hotkey.bind({"alt"}, "v", function()
```

把 `{"alt"}` 改成 `{"cmd","shift"}` 之类，把 `"v"` 改成别的字母即可。改完 Reload Config。

---

## 卸载
打开 `~/.hammerspoon/init.lua`，把以 `-- Option+V:` 开头的那一段（直到 `hs.alert.show(...)` 那一行）删掉，Reload Config 即可。要彻底卸载就把 Hammerspoon.app 拖进废纸篓。
