# Codex Dream Skin：Codex App 换肤 Skill 与自定义主题工具

Codex Dream Skin 是一个免费开源的 **Codex App 换肤 Skill**。它可以为 Codex Desktop 安装可交互的背景皮肤：macOS 支持自定义图片、CDN Banner、主题保存与切换，Windows 支持内置主题；两个平台都支持运行验证和恢复官方外观。

[![Skill CI](https://github.com/aithink001/Codex-Dream-Skin-Themes/actions/workflows/skill-ci.yml/badge.svg)](https://github.com/aithink001/Codex-Dream-Skin-Themes/actions/workflows/skill-ci.yml)
[![macOS](https://img.shields.io/badge/macOS-supported-22c55e)](#支持哪些系统和功能)
[![Windows](https://img.shields.io/badge/Windows-supported-2563eb)](#支持哪些系统和功能)
[![License](https://img.shields.io/badge/license-MIT-2563eb)](LICENSE)

原生侧栏、项目选择、建议卡片、任务内容和输入框仍然可以正常点击与输入；主题图片只用于 Banner 和装饰背景，不会把一张假界面截图盖在 Codex 上。

**[没有合适的背景图？打开 Codex Dream Skin Banner 在线生成器](https://image3.org/zh/codex-dream-skin-generator?utm_source=github&utm_medium=readme&utm_campaign=codex_dream_skin)**

[![粉系定制 Codex Dream Skin 完整界面效果](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/pink-custom.jpg)](https://image3.org/zh/codex-dream-skin-generator?theme=pink-custom&utm_source=github&utm_medium=hero&utm_campaign=codex_dream_skin)

[下载安装](#codex-dream-skin-下载与安装) · [自定义主题](#如何给-codex-更换自定义主题) · [功能对比](#支持哪些系统和功能) · [效果预览](#codex-dream-skin-效果预览) · [验证与恢复](#如何验证主题已经生效) · [常见问题](#常见问题)

## Codex Dream Skin 下载与安装

### 方法一：让 Codex 安装 Skill

把下面这段话发送给 Codex：

```text
请从这个 GitHub 仓库安装 codex-dream-skin Skill：
https://github.com/aithink001/Codex-Dream-Skin-Themes/tree/main/skills/codex-dream-skin

安装完成后，使用 $codex-dream-skin 检查当前系统并告诉我下一步。
```

重新打开 Codex 后，即可通过 `$codex-dream-skin` 使用主题安装、定制、验证和恢复功能。

### 方法二：手动安装

```bash
git clone --depth 1 https://github.com/aithink001/Codex-Dream-Skin-Themes.git
mkdir -p ~/.codex/skills
cp -R Codex-Dream-Skin-Themes/skills/codex-dream-skin ~/.codex/skills/
```

然后重新打开 Codex，并发送：

```text
使用 $codex-dream-skin 检查环境并安装 Codex Dream Skin。
```

## 如何给 Codex 更换自定义主题

### macOS：使用本地图片或 CDN Banner

准备一张横向图片，建议宽度不低于 2000px。可以直接把本地图片路径或 HTTPS CDN 地址交给 Skill：

```text
使用 $codex-dream-skin，把这张图片设置为我的 Codex 主题：
https://cdn.example.com/my-codex-banner.png

主题名称叫「Purple Night」。应用完成后运行 Verify 并保存验证截图。
```

还可以继续告诉 Codex：

```text
使用 $codex-dream-skin 列出我保存的主题，并切换到「Purple Night」。
```

macOS 支持：

- 本地 PNG、JPEG、HEIC、TIFF、WebP；
- HTTPS CDN 图片；
- 主题名称、标语、引用文字和强调色；
- 保存多套主题并快速切换；
- SwiftBar 菜单栏控制；
- 暂停皮肤、重新应用、验证截图和完整恢复。

### Windows：安装内置 Codex 主题

Windows 当前支持内置装饰主题、验证截图和安全恢复：

```text
使用 $codex-dream-skin 在 Windows Codex App 中安装主题，完成后运行 Verify。
```

Windows 版目前还不支持任意图片主题。需要自定义 Banner 时请使用 macOS 版本。

## 支持哪些系统和功能

| 功能 | macOS | Windows |
| --- | :---: | :---: |
| 安装 Codex Dream Skin | ✅ | ✅ |
| 保留原生侧栏、任务和输入框 | ✅ | ✅ |
| 自定义本地图片 | ✅ | 暂不支持 |
| 使用 HTTPS CDN Banner | ✅ | 暂不支持 |
| 保存和切换多套主题 | ✅ | 暂不支持 |
| SwiftBar 菜单栏控制 | ✅ | — |
| 自定义调试端口 | ✅ | ✅ |
| Verify 实时验证 | ✅ | ✅ |
| 输出验证截图 | ✅ | ✅ |
| 恢复 Codex 官方外观 | ✅ | ✅ |
| 构建可分发 ZIP | ✅ | — |

完整命令和高级选项见 [`codex-dream-skin/SKILL.md`](skills/codex-dream-skin/SKILL.md)。

## Codex Dream Skin 效果预览

下面的图片适合用来选择配色、构图和氛围。最终主题会保留 Codex 原生控件，实际效果以 Verify 截图为准。

<table>
  <tr>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=pink-custom&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/pink-custom.jpg" alt="粉系定制 Codex Dream Skin 主题效果" width="100%"></a><br>
      <strong>Pink Custom · 粉系定制</strong>
    </td>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=god-of-wealth&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/god-of-wealth.jpg" alt="财神打工版 Codex Dream Skin 主题效果" width="100%"></a><br>
      <strong>God of Wealth · 财神打工版</strong>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=red-white-scifi&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/red-white-scifi.jpg" alt="红白科幻 Codex App 自定义主题效果" width="100%"></a><br>
      <strong>Red-White Sci-Fi · 红白科幻</strong>
    </td>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=clear-custom&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/clear-custom.jpg" alt="清透定制 Codex App 换肤效果" width="100%"></a><br>
      <strong>Clear Custom · 清透定制</strong>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=inspiration-universe&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/inspiration-universe.jpg" alt="灵感小宇宙 Codex 换肤主题效果" width="100%"></a><br>
      <strong>Inspiration Universe · 灵感小宇宙</strong>
    </td>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=purple-night&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/purple-night.jpg" alt="紫夜限定 Codex Dream Skin 背景主题" width="100%"></a><br>
      <strong>Purple Night · 紫夜限定</strong>
    </td>
  </tr>
  <tr>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=miku-future&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/miku-future.jpg" alt="虚拟歌姬未来 Codex 自定义主题效果" width="100%"></a><br>
      <strong>Miku Future · 虚拟歌姬未来</strong>
    </td>
    <td width="50%" align="center">
      <a href="https://image3.org/zh/codex-dream-skin-generator?theme=stage-black-gold&utm_source=github&utm_medium=showcase&utm_campaign=codex_dream_skin"><img src="https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/stage-black-gold.jpg" alt="舞台黑金 Codex App 主题效果" width="100%"></a><br>
      <strong>Stage Black-Gold · 舞台黑金</strong>
    </td>
  </tr>
</table>

**[选择一个风格并生成自己的 Codex Dream Skin Banner](https://image3.org/zh/codex-dream-skin-generator?utm_source=github&utm_medium=showcase_cta&utm_campaign=codex_dream_skin)**

## Codex 换肤是怎样工作的

Skill 会启动官方 Codex Desktop，并通过只监听 `127.0.0.1` 的 Chromium DevTools Protocol 注入主题 CSS 和装饰层。它不会修改、替换或重新签名官方应用文件。

```text
Codex Dream Skin Skill
        ↓
启动官方 Codex + 本机回环 CDP
        ↓
注入主题 CSS、Banner 和装饰背景
        ↓
原生侧栏、项目、任务和输入框保持可交互
```

运行时固定到已检查的提交 `26c6c410e0e0bfc053356474620e17f934f483fc`，下载后会再次核对 Git commit。主题运行期间，请避免运行来路不明的本机程序；不再使用时可以随时运行 Restore 关闭主题和调试会话。

## 如何验证主题已经生效

发送下面的提示词：

```text
使用 $codex-dream-skin 验证当前主题，并保存一张验证截图。
```

Verify 会检查：

- 主题 CSS 和注入标记是否存在；
- 原生侧栏与输入框是否仍然可见；
- 首页 Banner、建议卡和项目选择是否正常；
- 是否出现横向溢出或装饰层遮挡点击；
- 页面重新加载后主题是否可以重新应用。

只有 Verify 通过，才表示当前 Codex Dream Skin 已正常运行。

## 如何卸载或恢复 Codex 官方外观

发送：

```text
使用 $codex-dream-skin 恢复 Codex 官方外观，并关闭主题调试会话。
```

恢复功能会移除主题 CSS 和装饰层，并恢复安装前保存的外观设置。macOS 还可以删除桌面启动器，Windows 可以选择恢复完整的安装前配置备份。

## 常见问题

### Codex Dream Skin 是官方功能吗？

不是。这是面向 Codex Desktop 的非官方开源换肤工具，与 OpenAI 没有隶属、认可或赞助关系。

### 它会修改 Codex.app 或 app.asar 吗？

不会。主题通过本机回环 CDP 运行，不会修改 `.app`、`app.asar`、`WindowsApps` 或官方代码签名。

### Codex Dream Skin 支持 Windows 吗？

支持。Windows 可以安装内置主题、运行 Verify、保存验证截图并恢复官方外观。任意图片主题目前仅支持 macOS。

### 可以使用自己生成的图片吗？

可以。macOS 支持本地图片和 HTTPS CDN 地址。建议使用横向构图，并让左侧保持简洁，以免影响原生标题和控件的可读性。

### Codex 更新后主题失效怎么办？

重新运行安装、启动和 Verify。Codex 更新可能改变界面结构，因此每次更新后都建议重新验证。

### 图片会保存在 GitHub 仓库里吗？

不会。展示图片全部通过 HTTPS CDN 加载，仓库不提交 JPG、PNG、WebP 等图片二进制。

## 项目文件

- [`skills/codex-dream-skin/SKILL.md`](skills/codex-dream-skin/SKILL.md) — install, customize, switch, verify, package, and restore workflows.
- [`skills/codex-dream-skin/scripts/dream-skin-macos.sh`](skills/codex-dream-skin/scripts/dream-skin-macos.sh) — macOS command wrapper.
- [`skills/codex-dream-skin/scripts/dream-skin-windows.ps1`](skills/codex-dream-skin/scripts/dream-skin-windows.ps1) — Windows command wrapper.
- [`prompts/themes.json`](prompts/themes.json) — machine-readable Codex theme Banner prompts.

## 开源许可与商标

仓库代码与文本采用 [MIT License](LICENSE)。外部 CDN 图片不随仓库许可证自动授权。Codex、OpenAI 以及相关商标归各自权利人所有；人物、角色或商标素材用于公开再分发或商业项目时，请自行确认相应授权。

---

**English:** Open-source Codex Dream Skin Skill for Codex Desktop themes on macOS and Windows. Install a reversible skin, use a custom image on macOS, verify the live native interface, and restore the official appearance at any time.
