# Data 数据

数据与模板分离是一个好的设计模式，我们也这么做。这里我们认为数据是以键值对的形式访问的。

## DataSource 数据源

数据源提供数据，或者提供访问数据的接口。

数据源要先声明在 `site.datasource-config` 里才可以使用。使用格式为：

```yaml
<name>:
    provider: <provider>
    config: <config>
```

已声明的数据源可以使用 `data@<name>.XXX` 访问。其中，被 `site.primary-datasource` 指向的数据源（称为默认数据源）可以直接使用 `data.XXX` 访问。

数据源的提供者需要实现以下接口：

- `initialize(name, config)`
- `key?(key) -> bool`
- `get(key) -> Object`
- `set(key, value)`

假设我们有如下的数据源配置：

```yaml
file:
    provider: DataSource::FileDataSource
    config: ...
```

那么 Weboot 会调用 `FileDataSource.new('file', config)` 创建一个实例。

当访问 `data@file.XXX` 时，Weboot 会调用 `get('XXX')` 获取数据，调用 `set('XXX', value)` 修改数据。

具体内部如何处理、存储键值对，需要查看对应数据源的文档或源码。

### FileDataSource 本地文件数据源

本地文件数据源是内建的，类路径是 `::Weboot::DataSource::FileDataSource`。

配置的格式为：

```yaml
dir: <data-root-dir>
readers:
  - suffix: <suffix>
    provider: <provider>
```

举个例子：

```yaml
dir: data
readers:
  - suffix: .json
    provider: Reader::JsonReader
```

FileDataSource 会遍历 `<project-root-dir>/data` 文件夹，找到文件名后缀为 `.json` 的那些文件，把文件内容交给 `::Weboot::Reader::JsonReader` 转换为 ruby 的 Hash / Array 对象。

对于多级目录，例如：文件 `<project-root-dir>/data/a/b.json` 的内容会被挂载到 `data@file.a.b.` 下。

## 访问和修改

数据能够在任意位置通过变量 `data.XXX` `data@<name>.XXX` 访问。

一般是以字符串变量的形式传递给其他参数，即 `${data.XXX}`。在模板里访问它则需要查询相应模板引擎提供的文档。

这些数据在每个页面间共享，在运行时任何钩子、过滤器作出的修改都会对之后用到它的地方产生影响。
