# Codex Dream Skin Skill

真正可执行、可验证、可恢复的 Codex Desktop 换肤 Skill，不是把效果图贴进窗口里冒充主题。

[![Codex Skill](https://img.shields.io/badge/Codex-Skill-111827)](skills/codex-dream-skin/SKILL.md)
[![Skill CI](https://github.com/aithink001/Codex-Dream-Skin-Themes/actions/workflows/skill-ci.yml/badge.svg)](https://github.com/aithink001/Codex-Dream-Skin-Themes/actions/workflows/skill-ci.yml)
[![macOS](https://img.shields.io/badge/macOS-supported-22c55e)](#实际支持范围)
[![Windows](https://img.shields.io/badge/Windows-supported-2563eb)](#实际支持范围)
[![Images](https://img.shields.io/badge/showcase_images-CDN-7c3aed)](#效果参考)

> **[在线生成可用于主题的超宽 Banner](https://image3.org/zh/codex-dream-skin-generator?utm_source=github&utm_medium=readme&utm_campaign=codex_dream_skin)**

## 这次是真的怎么用

这个仓库现在提供可安装的 [`codex-dream-skin` Skill](skills/codex-dream-skin/SKILL.md)。用户可以直接告诉 Codex：

```text
请从这个 GitHub 仓库安装 codex-dream-skin Skill：
https://github.com/aithink001/Codex-Dream-Skin-Themes/tree/main/skills/codex-dream-skin
```

也可以手动安装：

```bash
git clone https://github.com/aithink001/Codex-Dream-Skin-Themes.git
mkdir -p ~/.codex/skills
cp -R Codex-Dream-Skin-Themes/skills/codex-dream-skin ~/.codex/skills/
```

重新打开 Codex 后，可以这样使用：

```text
使用 $codex-dream-skin 检查我的电脑是否支持，并安装主题。
```

```text
使用 $codex-dream-skin，把这个 Banner 应用到 Codex：
https://你的-CDN-地址/banner.png
应用后生成验证截图；如果验证失败，不要说成功。
```

```text
使用 $codex-dream-skin 恢复 Codex 官方外观。
```

## 它实际做了什么

```text
Codex Skill
    │  下载并校验固定提交的主题运行时
    ▼
启动官方 Codex + 仅监听 127.0.0.1 的 CDP
    │  注入 CSS 和装饰 DOM
    ▼
原生侧栏 / 项目选择 / 建议卡 / 任务 / 输入框继续可交互
    │
    ├── Verify：检查真实页面标记并可保存实机截图
    └── Restore：移除注入并恢复保存的外观配置
```

- 不修改官方 `.app`、`app.asar` 或 `WindowsApps`。
- 不把整张“假 Codex 界面截图”覆盖在应用上。
- 不修改账号、对话、项目、API Key 或模型供应商。
- 实际执行引擎来自公开的 [`Codex-Dream-Skin`](https://github.com/Fei-Away/Codex-Dream-Skin) 运行时；Skill 固定到已检查的提交 `26c6c410e0e0bfc053356474620e17f934f483fc`，拉取后再次核对 Git commit。
- 只有 Verify 通过才允许声称“已经生效”。下载图片、运行安装脚本都不等于验证成功。

## 实际支持范围

| 能力 | macOS | Windows |
| --- | :---: | :---: |
| 安装真实注入器 | ✅ | ✅ |
| 启动前询问是否重启 Codex | ✅ | ✅ |
| 实时注入 CSS / 装饰 DOM | ✅ | ✅ |
| 运行 Verify | ✅ | ✅ |
| 输出实机验证截图 | ✅ | ✅ |
| 使用自定义 Banner | ✅ | 暂不承诺 |
| 保存主题库并快速切换 | ✅ | — |
| 查看状态 / 暂停后恢复 | ✅ | — |
| SwiftBar 菜单栏控制 | ✅ | — |
| Renderer reload 后重新注入验证 | ✅ | 需实机检查 |
| 自定义调试端口 | ✅ | ✅ |
| 前台 Injector 诊断 | ✅ | ✅ |
| 不创建快捷方式安装 | ✅ | ✅ |
| 精确恢复安装前 config | — | ✅ |
| 不重新打开 Codex 的恢复 | — | ✅ |
| 构建客户 ZIP / 发布 ZIP | ✅ | — |
| 恢复官方外观 | ✅ | ✅ |

当前 Windows 运行时提供内置主题和安全恢复，但还没有与 macOS 同等级的任意图片定制流程。因此仓库不会写成“Windows 可随便换图”。

完整命令、安全说明和验证方式见 [`SKILL.md`](skills/codex-dream-skin/SKILL.md)。`start-authorized` 和 `restore-authorized` 适合已经确认重启、需要无二次弹窗的自动化场景。

## 安全边界

主题通过本机 Chromium DevTools Protocol 工作。端口只绑定 `127.0.0.1`，但 CDP 对同一台电脑上的本地程序没有用户级认证。

- 主题运行期间不要运行来路不明的本机程序。
- Codex 正在运行时，重启前会显示确认提示，避免意外丢失尚未提交的输入。
- Codex 更新后重新运行 Verify；DOM 结构变化可能导致主题失效。
- 不想继续使用时运行 Restore，关闭主题注入与调试会话。

## 自定义 Banner

在线生成器只负责生成适合注入器使用的 Banner，不会伪造一个不可点击的 Codex 界面：

**[打开 Codex Dream Skin Banner 生成器](https://image3.org/zh/codex-dream-skin-generator?utm_source=github&utm_medium=banner_workflow&utm_campaign=codex_dream_skin)**

建议：

- 使用 HTTPS CDN 地址；
- 选择横向图片，建议宽度不低于 2000px；
- 左侧保持相对干净，给原生标题和控件留空间；
- 只生成背景艺术，不生成假侧栏、假输入框、假按钮和水印。

所有展示图片均使用外部 CDN，仓库不保存 JPG、PNG、WebP 等图片二进制。

## 效果参考

下面的图片用于选择视觉方向，不等于仓库承诺可以 1:1 复刻整张界面。真正结果以 Skill 的实机 Verify 为准。

### Pink Custom / 粉系定制

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/pink-custom.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=pink-custom&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![粉系定制 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/pink-custom.jpg)

### God of Wealth / 财神打工版

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/god-of-wealth.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=god-of-wealth&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![财神打工版 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/god-of-wealth.jpg)

### Red-White Sci-Fi / 红白科幻

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/red-white-scifi.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=red-white-scifi&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![红白科幻 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/red-white-scifi.jpg)

### Clear Custom / 清透定制

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/clear-custom.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=clear-custom&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![清透定制 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/clear-custom.jpg)

### Inspiration Universe / 灵感小宇宙

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/inspiration-universe.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=inspiration-universe&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![灵感小宇宙 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/inspiration-universe.jpg)

### Purple Night / 紫夜限定

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/purple-night.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=purple-night&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![紫夜限定 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/purple-night.jpg)

### Miku Future / 虚拟歌姬未来

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/miku-future.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=miku-future&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![虚拟歌姬未来 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/miku-future.jpg)

### Stage Black-Gold / 舞台黑金

[查看完整参考图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/stage-black-gold.jpg) · [生成原创 Banner](https://image3.org/zh/codex-dream-skin-generator?theme=stage-black-gold&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![舞台黑金 Codex Dream Skin 效果参考](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/stage-black-gold.jpg)

## 仓库内容

- [`skills/codex-dream-skin/SKILL.md`](skills/codex-dream-skin/SKILL.md)：Codex 执行规范与验证规则。
- [`skills/codex-dream-skin/scripts/dream-skin-macos.sh`](skills/codex-dream-skin/scripts/dream-skin-macos.sh)：macOS 安装、定制、主题库、状态、暂停、菜单栏、验证、打包和恢复入口。
- [`skills/codex-dream-skin/scripts/dream-skin-windows.ps1`](skills/codex-dream-skin/scripts/dream-skin-windows.ps1)：Windows 安装、启动、诊断、验证、精确配置恢复和卸载入口。
- [`prompts/themes.json`](prompts/themes.json)：可机器读取的 Banner 风格提示词。

## 声明

这是非官方项目，与 OpenAI 没有隶属、认可或赞助关系。Codex 及相关商标归其权利人所有。效果参考中的人物、角色或商标用于公开再分发或商业用途前，请自行确认相应权利。

仓库代码和文本许可见 [LICENSE](LICENSE)。外部 CDN 图片不随仓库许可证自动授权。
