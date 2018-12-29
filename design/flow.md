
```raw
file --pipeline--> page
```

config 是配置，配置分为全局配置和文件配置和本地两者

```raw
load-config-file
load-data
    traverse-data-dir
    sort
    read-file
    parse-data
    merge-data
scan-files
    traverse-file-root-dir
    for dir in subdirs
        dir.load-metadata
        traverse-dir-recursively
    for file in files
        file.load-metadata
process-files
    merge-config
    pre-hooks
    decide-pipeline
    pipeline.run
        page.from file
        pre-hooks
        for filter in filters
            pre-hooks config, page, filter
            page = filter.run page
            post-hooks config, page
        post-hooks
        page.output
    post-hooks
after-weboot
```
