# 数据

数据与模板分离是一个好的设计模式，我们也这么做。这里我们认为数据是以键值对的形式访问的。

## 数据源（datasource）

数据源提供数据，或者提供访问数据的接口。

数据源配置在 `site.datasource-config` 里，格式为：

```yaml
<name>:
    provider: <provider-syntax>
    config: <config>
```

配置好的数据源可以使用 `data@<name>.XXX` 访问。

`site.primary-datasource` 指向的数据源被视为默认源，可以直接使用 `data.XXX` 访问。

数据源的提供者需要实现以下接口：

- `initialize(name, config)`
- `key?(key) -> bool`
- `get(key) -> Object`
- `set(key, value)`

假设我们有如下的数据源配置：

```yaml
file:
    provider: builtin://FileDatasource
    config: ..
```

那么 Weboot 会调用 `FileDatasource.new('file', config)` 创建一个实例。

当访问 `data@file.XXX` 时，Weboot 会调用 `get('XXX')` 获取数据，调用 `set('XXX', value)` 修改数据。

具体内部如何处理、存储键值对，需要查看对应数据源的文档或源码。

### 本地文件数据源

本地文件数据源是内建的，URI 是 `builtin://FileDatasource`。

配置如下例：

```yaml
dir: <data-root-dir>
readers:
  - suffix: .json
    provider: builtin://Stream::JsonReader
```

FileDatasource 会遍历 `data-root-dir` 及其子目录，读取文件，根据后缀名交由相应的读取器转换为 ruby 的 Hash / Array 对象。

如：文件 `<data-root-dir>/a/b.json` 的内容会被挂载到 `data@file.a.b.` 下。



数据通过以下各项自上而下合并（后者覆盖前者）得到：

1. `${site.default-data}`
1. `${site.data-source}` 列表的每一项

## 访问和修改

数据能够在任意位置通过变量 `data.XXX` `data@<name>.XXX` 访问。

一般是以字符串变量的形式传递给其他参数，即 `${data.XXX}`。在模板里访问它则需要查询相应模板引擎提供的文档。

这些数据在每个页面间共享，在运行时任何钩子、过滤器作出的修改都会对之后用到它的地方产生影响。
