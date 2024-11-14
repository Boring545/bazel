# Bazel 6.5.0 for RISC-V 构建指南

感谢 [6eanut](https://github.com/6eanut) 在构建 Bazel 6.5.0 for RISC-V 版本中所做的努力。此文档提供了在 RISC-V 架构下构建 Bazel 6.5.0 的步骤和资源。

## 相关资源

1. **Bazel 6.5.0 for RISC-V 构建指南**  
   您可以参考以下链接，了解在 RISC-V 环境中构建 Bazel 6.5.0的一些思路：
   - (https://github.com/6eanut/NOTEBOOK/blob/main/24-Q3/build-bazel-riscv.md)

## 构建步骤

1. 执行 `build.sh` 脚本，以构建一个 RISC-V 可用的 Bazel 6.5.0。
2. 执行以下命令，将构建好的 Bazel 二进制文件移动到指定目录：

   ```bash
   mkdir -p ~/local/bazel
   mv ../bazel-6.5.0-riscv64/* ~/local/bazel
   ```

3. 将 `export PATH=$HOME/local/bazel/bin:$PATH` 添加到 `~/.bashrc` 文件中，并执行以下命令使修改生效：

   ```bash
   source ~/.bashrc
   ```
4. 执行`bazel version`检查是否可用
