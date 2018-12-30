# Flow 流程

Weboot 的目的是从源文件生成、输出目标页面。

```raw
source file --rendering--> page --output--> target file
```

Weboot 的工作分为以下几个阶段：

1. 加载配置
1. 加载数据源
1. 扫描源文件，加载页面配置
1. 生成页面
1. 将页面写入文件

详细工作过程如下：

```raw
weboot.run
    load-site-config
    datasources.each initialize
    scanning
        [source-dir, subdirs, sub-subdirs..].each
            load-dir-config
            file.each
                load-file-header
                merge-page-config
        after-scanning
    rendering
        file.each
            page.init
            decide-pipeline
            pipeline.run
                filters.each run-on-page
        after-rendering
    writing
        page.each write
        after-writing
```
