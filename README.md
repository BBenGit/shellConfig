# shellConfig

shellConfig is a tool that automatically prepares your environment, both on **zsh** and **bash**. It gives you a set of pre-configured aliases, functions and others.

# How to install

## Get shellConfig

The first step in the installation process is to get the installer from the Web. This is a shell script that lets you install what you like. It need to obtain the executable rights if you want to start it implicitely.

```bash
curl -o install.sh https://code.guillaume-bernard.fr/guilieb/shellConfig/raw/master/install.sh
chmod +x ./install.sh
```

## Install

The installer lets you install [libShell](https://code.guillaume-bernard.fr/guilieb/libShell), [OhMyZsh](https://ohmyz.sh/), [PowerlineFonts](https://github.com/powerline/fonts), [shellConfig](https://code.guillaume-bernard.fr/guilieb/shellConfig). You can decide not to use this latest. The option “--all“ does everything for you.

```bash
        install.sh [-h] [--help]
                   [--libshell]
                   [--oh-my-zsh]
                   [--powerline-fonts]
                   [--shell-config]
                   [--use-shell-config]
                   [--all]

        --libshell: install LibShell in the user's current home directory

        --oh-my-zsh: install Oh-My-ZSH in the user's current home directory. In
                     order to run properly, you must install zsh.

        --powerline-fonts: install powerline fonts for the current user

        --shell-config: install ShellConfig on the system. Implies installing
                        libShell as well.

        --use-shell-config: enable ShellConfig default configuration (replaces
                            any custom .profile, .bashrc or .zshrc

        --all: install libShell, Powerline fonts, ShellConfig and OhMyZsh.
```

## Configure

Once installed, please reload you shell. Then you’ll be able to import a directory containing scripts of your own. This is made possible with the command **importShellConfigExternalDirectory** with accepts one argument: the path to the directory containing your scripts.
```bash
importShellConfigExternalDirectory ~/Documents/Informatique/Configuration/Scripts\ externes
```

In order to benefit from all the available possibilities, you can also import a shellConfig configuration file. You have an example in this repository, called **shellConfig.conf.example**. Feel free to copy and modify it. You can import it via the **importShellConfigSetupFile** command, giving the path to your file as first argument.
```
importShellConfigSetupFile ~/Documents/Informatique/Configuration/local/shellconfig.vars
```

## Full example

```bash
# get the script
curl -o install.sh https://code.guillaume-bernard.fr/guilieb/shellConfig/raw/master/install.sh
chmod +x ./install.sh

# install
./install.sh --all

# setup
importShellConfigSetupFile ~/Documents/Informatique/Configuration/local/shellconfig.vars
importShellConfigExternalDirectory ~/Documents/Informatique/Configuration/Scripts\ externes
```

# How to customize

If you decide to enable shellConfig, you can change a few files :
* bashrc if you use bash;
* zshrc if you use zsh;
* shellrc if you want to apply a configuration to both.