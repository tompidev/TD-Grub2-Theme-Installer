# TompiDev GRUB 2 Theme Installer

[![License](https://img.shields.io/badge/Licence-MIT-green.svg)](LICENSE)
[![Latest](https://img.shields.io/badge/Download-latest-blue)](https://github.com/tompidev/TD-Grub2-Theme-Installer/releases/latest)

## 🚀 Installation

### Direct download method

Simply download the latest release from the [right side  👉](https://github.com/tompidev/TD-Grub2-Theme-Installer/releases)

**After normal download you need to unzip the package first!**

#### Installation

Go to the extracted "TD-Grub2-Theme-Installer" folder, and then:

1. right click anywhere an empty space
2. Choose 'Open Terminal here' (or something similar)
3. Enter the following command:

```bash
 sudo ./install.sh
```

### Using terminal enter the following command :

```bash
 git clone https://github.com/tompidev/TD-Grub2-Theme-Installer
 cd TD-Grub2-Theme-Installer
 sudo ./install.sh
```

💡 *With the "git clone" method, the package will be downloaded to the Home folder on your computer.*

## 💻 Dependencies

**TompiDev GRUB 2 Theme Installer** requires the following dependencies (in case git clone):

- git

#### 🐧 Install git (Linux)

```bash
 sudo apt-get install --assume-yes git
```

## ⬇️ How to add Themes to the directory

Do you want to set more Themes?

I show you how can you do this.

- First download the desired theme to your PC. 
  Downloads library you find here: [GRUB Themes - KDE Store](https://store.kde.org/browse?cat=109&ord=latest) or here [GRUB Themes - Gnome-look.org](https://www.gnome-look.org/browse?cat=109&ord=latest)

- Unzip the downloaded file and copy this unzipped folder into the Themes directory inside the "TD-Grub2-Theme-Installer" folder.

  (Look at the correct directory structure inside the themes folder)

- Now follow the steps of the [Installation process](#installation)

## 🗑️ How to remove Themes from the Directory

Do you want to delete an old Theme?

Just go to the Themes directory inside the "TD-Grub2-Theme-Installer" folder and delete the whole folder of the not desired Theme.

---

## ⚙️ How the script works?

The script reads the folder names of the whole Themes directory and creates a list from it.

If you delete a folder it will be no more shown on the list.

If you added a new Theme folder the script will see and display it in the list.

When you run the script, you get this numbered list.

You need only Enter the desired template number from the list and press Enter.

The rest of the work is done by the script.

## 🌐  Languages

* English

* German

* Hungarian

## 🔄 Compatibility

The script has been tested on the following Distros:

* Linux Mint 20
* Ubuntu 20.04/21.04
* Kubuntu 20.04/21.04
* KDE Neon

## 📜 License

Copyright (c) 2021 &quot;TompiDev&quot; &lt;support@tompidev.com&gt;

Distributed under the MIT license.

Thank you for your rating or star voting!

If you have any idea or a question please don not hesitate just write me!
