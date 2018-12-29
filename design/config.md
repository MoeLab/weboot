# 配置

## 全站配置（site config）

全站配置能够通过变量 `site.XXX` 访问。全站配置在每个页面间共享。

全站配置由项目根目录下的 `config.yaml` 定义。

## 页面配置（page config）

页面配置能够通过变量 `page.XXX` 访问。每个页面都有其单独的页面配置。

页面配置通过以下各项自上而下合并（后者覆盖前者）得到：

1. `site.default-page-config`
1. `site.source-dir` 目录及其子目录下的 `_config.yaml` 文件
1. 源文件内的 YAML 头

## 运行时修改配置

在运行时，每个钩子、过滤器等均有权访问和修改配置。

对于全站配置，一经修改则会对所有引用之处均生效。

对于页面配置，修改仅在当前页面的流水线内生效。