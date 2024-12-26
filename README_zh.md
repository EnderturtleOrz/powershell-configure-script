[English](README.md) | **简体中文** 

# PowerShell 配置脚本

此仓库包含一个 PowerShell 脚本，用于安装和配置各种模块，并将内容追加到您的 PowerShell 配置文件中。

## 如何使用

1. 克隆此仓库到您的本地机器。
2. 以管理员身份打开 PowerShell。
3. 运行 `init.ps1` 脚本：

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\init.ps1
```

4. 按提示选择所需的配置模式。

## 配置模式

- **Yes (Y)**: 安装并配置所有模块，并将所有内容追加到 `$PROFILE`。
- **Customize (C)**: 选择性安装和配置或更新选定的模块。
- **No (N)**: 退出脚本。

## 如何贡献？

配置和其他模块？请参阅 [config/README.md](config/README.md)。

初始化脚本？直接 PR!!

欢迎提交问题和 PR!!!

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=EnderturtleOrz/powershell-configure-script&type=Date)](https://star-history.com/#EnderturtleOrz/powershell-configure-script&Date)