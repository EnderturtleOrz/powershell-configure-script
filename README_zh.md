[English](README.md) | **简体中文** 

# PowerShell 配置脚本

此仓库包含一个 PowerShell 脚本，用于安装和配置各种模块，并将内容追加到您的 PowerShell 配置文件中。

## 功能

- 安装和配置 PowerShell 模块
- 将自定义内容追加到您的 PowerShell 配置文件
- 易于自定义和扩展

## 如何使用

1. 克隆此仓库到您的本地机器：
    ```sh
    git clone https://github.com/EnderturtleOrz/powershell-configure-script.git
    cd powershell-configure-script
    ```

2. 以管理员身份更改脚本策略：
    ```sh
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

3. 运行脚本：
    ```sh
    ./init.ps1
    ```

4. 按屏幕上的说明安装和配置模块。

## 要求

- PowerShell 5.1 或更高版本
- 管理员权限以更改执行策略

## 许可证

此项目根据 MIT 许可证授权 - 有关详细信息，请参阅 [LICENSE](LICENSE) 文件。

## 如何贡献？

配置和其他模块？请参阅 [config/README.md](config/README.md)。

欢迎贡献！请打开一个 issue 或提交一个 pull request。

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=EnderturtleOrz/powershell-configure-script&type=Date)](https://star-history.com/#EnderturtleOrz/powershell-configure-script&Date)