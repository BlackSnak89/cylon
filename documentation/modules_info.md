Modules files overview
------------------
There are twelve module library files containing 29 functions.
installed to 
```sh
/usr/lib/cylon/modules/
```
These files contain the functions used by script.
Function headers in the files contain more information.

| File name | Functions |
| ------ | ------ |
| AntiMalware_module | SystemSecFunc AntiMalwareFunc intchkFunc |
| Gdrive_module | gdriveFunc |
| Pacaur_module | pacaurFunc |
| System_back_module | SystemBackFunc |
| Ccrypt_module | ccryptFunc |
| Misc_module | checkinputFunc DisplayFunc exitHandlerFunc HelpFunc msgFunc readconfigFunc weatherFunc makeDirFunc |
| Pacman_module | pacmanFunc pkglistFunc updateFunc checkPacFunc rssFunc |
| System_clean_module | SystemCleanFunc |
| Cower_module | DelQmeFunc cowerFunc |
| Network_module | networkFunc checknetFunc |
| Rmlint_module | RmLintFunc |
| System_maint_module | SystemMaintFunc SystemMaintAutoFunc configFileScanFunc |

| Function name | Description |
| ------ | ------ |
| SystemSecFunc | Display security options menu |
| AntiMalwareFunc | Handles rkhunter, clamscan and lynis applications|
| intchkFunc | Checks if string input is an integer |
| gdriveFunc | gdrive wrapper |
| pacaurFunc | pacaur wrapper |
| SystemBackFunc | System backup options |
| ccryptFunc | ccrypt wrapper |
| checkinputFunc| Check options from command line passed to program on start |
| DisplayFunc | Displays main menu options |
| exitHandlerFunc | Error handler to with deal with user errors and exits |
| HelpFunc | Displays cylon and system information pages |
| msgFunc  | Prints to screen: lines, text, 'anykey' prompt and 'yes or no' prompt |
| readconfigFunc | Deals with viewing and editing of cylonCfg.conf config file |
| weatherFunc | Displays weather forecast |
| makeDirFunc | Creates the directories for program output folder |
| pacmanFunc | pacman wrapper + various utilities |
| pkglistFunc | Creates a list of files containing package information |
| updateFunc | Handles the full system update routine |
| checkPacFunc | Checks if package installed  |
| rssFunc | Arch Linux News reader of the Rss feed https://www.archlinux.org/feeds/news/ |
| SystemCleanFunc | bleachbit wrapper |
| DelQmeFunc | Delete foreign packages display menu |
| cowerFunc | cower wrapper + extended functionality  |
| networkFunc | Handles the network options |
| checknetFunc | Checks if network has connectivity with netcat |
| RmLintFunc | rmlint wrapper |
| SystemMaintFunc | Carries out maintenance checks from menu selection |
| SystemMaintAutoFunc | Carries out most maintenance checks in a single pass |
| configFileScanFunc | Scans home folder for old configuration files |
