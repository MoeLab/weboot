# Weboot 的设计

在开发 Weboot 之前，作者使用了一段时间的 Jekyll。在使用过程中，作者觉得 Jekyll 有很多相似却又在细微处不同的特殊设置，如 collections 里要单独抽出来一个 posts 限制它的文件命名规则，如区分 Convertible 和 Forwardable 两种文件。就好像它在主动而生硬地限制自己，明明没必要分开对待的的概念，却一定要予以区分。这令作者觉得不够优雅，进而萌生了重复造轮子的想法。

Weboot 的思路是，只给出生成静态网站所需的流程规则，尽可能地提供定制页面的自由。

## 目录

- [流程](flow.md)
- [配置](config.md)
- [提供者](provider.md)
- [数据源](datasource.md)
- [页面生成](rendering.md)
- [钩子](hook.md)
- [插件](plugin.md)
