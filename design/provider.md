# Provider 提供者

Weboot 的每个可定制组件都接受一个实现了特定接口的提供者。

提供者的来源有两种：内置（Builtin）、插件（Plugin）。

提供者的使用者需要做以下两件事：

1. 如果提供者来自插件，需要先将提供者代码放进 `site.plugin-dir` 指向的路径；
1. 在 `provider` 字段中填写提供者的类路径。

这里有两处需要注意：

- `site.plugin-dir` 及各处 dir 字段的当前路径均为项目根目录；
- `provider` 字段的当前路径为 `::Weboot`。

dir 字段中，你可以使用相对路径，也可以使用绝对路径：

- 相对路径：`a/b` 实际指向 `<project-root-dir>/a/b`
- 绝对路径：`/a/b`

`provider` 字段中，你可以使用相对路径，也可以使用绝对路径：

- 相对路径：`Hook::NopHook` 实际指向 `::Weboot::Hook::NopHook`
- 绝对路径：`::Weboot::Hook::NopHook`

因为文件系统路径和类路径都可以填写绝对路径或相对路径，所以请格外留意。

有关开发提供者的内容，请参见 [Plugin](plugin.md)。
