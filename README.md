# Codex Dream Skin Themes

8 套完整 Codex Dream Skin 换肤效果，以及可以继续生成原创 Banner 的风格提示词。

[![Showcases](https://img.shields.io/badge/showcases-8-7c3aed)](#完整效果预览)
[![Prompts](https://img.shields.io/badge/prompts-ready-0ea5e9)](prompts/themes.json)
[![Images](https://img.shields.io/badge/images-CDN-22c55e)](#素材说明)

> **[在线查看完整大图并生成自己的 Codex 主题](https://image3.org/zh/codex-dream-skin-generator?utm_source=github&utm_medium=readme&utm_campaign=codex_dream_skin)**

![舞台黑金 Codex Dream Skin](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/stage-black-gold.jpg)

## 这个仓库提供什么

- 8 套完整 Codex 界面效果参考
- 粉系、财神、红白科幻、清透、ENFP、紫夜、虚拟歌姬和黑金方向
- 每套对应一条可继续生成原创 Banner 的提示词
- 可机器读取的 [`prompts/themes.json`](prompts/themes.json)
- 所有图片均由独立 CDN 提供，仓库内不存放图片二进制

这里不包含安装器，不修改应用文件，也不会更改任何 Codex 配置。在线生成器负责制作主题 Banner；具体换肤请使用你自己的 Codex 主题工作流。

## 完整效果预览

### Pink Custom / 粉系定制

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/pink-custom.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=pink-custom&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![粉系定制](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/pink-custom.jpg)

### God of Wealth / 财神打工版

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/god-of-wealth.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=god-of-wealth&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![财神打工版](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/god-of-wealth.jpg)

### Red-White Sci-Fi / 红白科幻

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/red-white-scifi.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=red-white-scifi&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![红白科幻](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/red-white-scifi.jpg)

### Clear Custom / 清透定制

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/clear-custom.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=clear-custom&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![清透定制](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/clear-custom.jpg)

### Inspiration Universe / 灵感小宇宙

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/inspiration-universe.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=inspiration-universe&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![灵感小宇宙](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/inspiration-universe.jpg)

### Purple Night / 紫夜限定

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/purple-night.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=purple-night&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![紫夜限定](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/purple-night.jpg)

### Miku Future / 初音未来

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/miku-future.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=miku-future&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![初音未来](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/miku-future.jpg)

### Stage Black-Gold / 舞台黑金

[查看完整大图](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/stage-black-gold.jpg) · [生成同款风格](https://image3.org/zh/codex-dream-skin-generator?theme=stage-black-gold&utm_source=github&utm_medium=theme&utm_campaign=codex_dream_skin)

![舞台黑金](https://cdn.nano-banana-2-ai.com/uploads/codex-dream-skin/showcases/stage-black-gold.jpg)

## 从效果图生成自己的 Banner

完整效果图适合判断方向，但生成时不要把整套假 UI 画进背景。建议保留下面的结构：

```text
主题身份 + 视觉主体 + 主色和辅助色 + 装饰元素 + 情绪 + 超宽 Banner 构图

Create a production-ready panoramic 3:1 Codex desktop theme banner.
Keep the left side readable for native interface titles and place the main visual focus on the right half.
Generate banner artwork only: no fake app chrome, no fake input field, no small unreadable text,
no logos, and no watermark. The image must remain usable when center-cropped.
```

仓库中的全部风格提示词位于 [`prompts/themes.json`](prompts/themes.json)。

## 素材说明

- 图片使用稳定 HTTPS CDN，不依赖 GitHub Raw。
- 仓库不提交 JPG、PNG、WebP 等图片二进制。
- 效果图用于视觉参考；人物肖像、角色形象或商标用于商业项目时，请先确认相应权利。
- 更稳妥的商业用法是保留构图、配色和氛围，生成原创人物或原创角色。

## English

This repository contains eight complete Codex Dream Skin showcases and prompt directions for generating an original ultra-wide banner.

- Complete full-interface references
- CDN-hosted images; no image binaries in the repository
- Machine-readable prompts in [`prompts/themes.json`](prompts/themes.json)
- Online generator for original variations

**[Create a custom Codex theme online](https://image3.org/codex-dream-skin-generator?utm_source=github&utm_medium=readme&utm_campaign=codex_dream_skin)**

Showcase images are visual references. Confirm portrait, character, and trademark rights before commercial reuse.

## Contributing

欢迎提交新的原创方向和提示词。请先阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

## License

仓库中的代码和文本许可见 [LICENSE](LICENSE)。外部 CDN 效果图不随仓库许可证自动授权。
