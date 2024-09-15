# FIFA19 Tools Installer

> ###### Tested on: Windows 10, 11 (x64, PowerShell v5)

Easily set up the Frosty Mod Manager and Extreme Injector to install FIFA 19 modifications and avoid problems.

- Installs **Frosty Mod Manager** and **Extreme Injector**
- Fixes `Error: empty path name is not legal.`
- Creates shortcuts on **Desktop** and **Start Menu**
- Copies **Frosty FIFA19 key** to clipboard

## Usage

1. #### Go to your FIFA 19 directory
2. #### Open PowerShell window here
    > ![image](https://github.com/boredwz/fifa19_tools_installer/assets/87862400/d334e1bb-a931-4642-bb57-879940e4bcae)
3. #### Copy and run this command:
    ```
    . $([scriptblock]::Create((iwr -useb 'https://raw.githubusercontent.com/boredwz/fifa19_tools_installer/master/FIFA19_Tools_Installer.ps1')))
    ```
## Uninstall
1. #### Go to your FIFA 19 directory
2. #### Open PowerShell window here
3. #### Copy and run this command:
    ```
    . $([scriptblock]::Create((iwr -useb 'https://raw.githubusercontent.com/boredwz/fifa19_tools_installer/master/FIFA19_Tools_Installer.ps1'))) -Uninstall
    ```

## Credits

#### [ExtractArchive.ps1](https://gist.github.com/boredwz/aa1d1c486166a82a0899269c6161974f) (Author: boredwz)

#### [Frosty Mod Manager](https://github.com/CadeEvs/FrostyToolsuite) (Author: CadeEvs)

#### [FIFA19key](https://www.fifermods.com/frosty-key) (Author: fifermods)

#### [Extreme Injector](https://github.com/master131/ExtremeInjector) (Author: master131)
