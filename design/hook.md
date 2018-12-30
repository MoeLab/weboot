# Hook 钩子

钩子是在特定阶段被触发的代码块。

钩子要先声明在 `site.hooks` 里才可以使用。格式为：

```yaml
<name>:
  provider: <provider>
  config: <config>
 ```
 
如果不需要提供配置，则可以直接使用提供者类路径。即：

```yaml
<name>: <provider>
```

已声明的钩子的使用格式为：

```yaml
name: name
config: <config>
```

这里的 `config` 字段将覆盖 `site.hooks.<name>.config` 中的同名项。

如果不需要覆盖配置，则可以直接使用钩子名，即：

```yaml
<name>
```

目前 Weboot 有以下阶段可配置钩子：

- scanning
- rendering
- writing

如：

```yaml
after-scanning: # 在 scanning 阶段结束后执行
  - <hook>
```

此外，虽然过滤器 NopFilter 本身不修改页面，但是它的配置中接受一个 `hooks` 字段。

如：

```yaml
hooks:
  nop: Hook::NopHook

filters:
  nop: Filter::NopFilter

pipelines:
  - name: <name>
    suffix: <suffix>
    filters:
      - name: nop  # NopFilter
        config:    # config for NopFilter
          hooks:
            - name: nop  # NopHook
              config:    # config for NopHook
                ...
```
