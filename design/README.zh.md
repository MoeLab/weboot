# Weboot 的设计

在开发 Weboot 之前，作者使用了一段时间的 Jekyll。在使用过程中，作者觉得 Jekyll 有很多相似却又在细微处不同的特殊设置，如 collections 里要单独抽出来一个 posts 限制它的文件命名规则，如区分 Convertible 和 Forwardable 两种文件。就好像它在主动而生硬地限制自己，明明没必要分开对待的的概念，却一定要予以区分。这令作者觉得不够优雅，进而萌生了重复造轮子的想法。

Weboot 的思路是，只给出生成静态网站所需的流程规则，尽可能地提供定制页面的自由。

## 基本概念

### 文件

### 数据

数据与模板分离是一个好的设计模式，我们也这么做。

数据能够通过变量 `${data.XXX}` 访问。

数据来自 `${site.data-source-dir}` 指向的目录。Weboot 会遍历该目录及其子目录，按照 `${site.data-source-parsers}` 下的 parser 和 config 解析数据。

如：`${site.data-source-dir}/a/b.json` 的内容会被挂载到 `${data.a.b.}` 下。

### 流水线（Pipeline）

文件经过流水线后成为页面，

### 过滤器（Filter）



### 钩子 Hook

### 设置

Weboot 的配置分为两种，全站设置（site config）和文件设置（file config）。

全站设置能够通过变量 `${site.XXX}` 访问。文件设置能够通过变量 `${file.XXX}` 访问。

全站设置由项目根目录下的 `config.yaml` 定义。

文件设置则通过以下各提供方自上而下合并（后者覆盖前者）得到：

- `${site.default-file-config}`
- 从 `${site.file-root-dir}` 到文件所在目录的各级目录下的 `_config.yaml` 文件
- 文件内 YAML 头
