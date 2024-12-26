**English** | [简体中文](README_zh.md) 

# PowerShell Configuration Script

This repository contains a PowerShell script to install and configure various modules and append content to your PowerShell profile.

## How to Use

1. Clone this repository to your local machine.
2. Open PowerShell as an administrator.
3. Run the `init.ps1` script:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\init.ps1
```

4. Follow the prompts to select the desired configuration mode.

## Configuration Modes

- **Yes (Y)**: Install and configure all modules and append all content to `$PROFILE`.
- **Customize (C)**: Selective install and configure or update selected modules.
- **No (N)**: Exit the script.

## How to Contribute?

Configures and other modules? see [config/README.md](config/README.md).

Initialization script? Direct PR!!


Welcome issues and PRs !!!

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=EnderturtleOrz/powershell-configure-script&type=Date)](https://star-history.com/#EnderturtleOrz/powershell-configure-script&Date)