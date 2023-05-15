# fifa19_tools_installer

Easily set up the Frosty Mod Manager and Extreme Injector to install FIFA 19 modifications and avoid problems.

- Installs `Frosty Mod Manager` and `Extreme Injector`
- Fixes `Error: empty path name is not legal.`
- Creates shortcuts on `Desktop` and `Start Menu`

## Using

- #### Go to your FIFA 19 directory
- #### Open PowerShell window here
    > ![image](https://github.com/wvzxn/fifa19_tools_installer/assets/87862400/d334e1bb-a931-4642-bb57-879940e4bcae)
- #### Copy and run this command:
  ```
  [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;. $([scriptblock]::Create((iwr -useb 'https://raw.githubusercontent.com/wvzxn/fifa19_tools_installer/master/FIFA19_Tools_Installer.ps1')))
  ```

## Credits

#### [Get-FileFromWeb.ps1](https://gist.github.com/ChrisStro/37444dd012f79592080bd46223e27adc) (Author: ChrisStro)

#### [ExtractArchive.ps1](https://gist.github.com/wvzxn/8f326deb99c3267ecf741a21fa73becb) (Author: wvzxn)

#### [Frosty Mod Manager](https://github.com/CadeEvs/FrostyToolsuite) (Author: CadeEvs)

#### [Extreme Injector](https://github.com/master131/ExtremeInjector) (Author: master131)
