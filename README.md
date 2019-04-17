# shellConfig

shellConfig is a tool that automatically configures your shell environment. It works on both **zsh** (> 5.1) and **bash**. It offers you some aliases, useful functions by installing *[libShell](https://github.com/guilieb/libShell)*.

It can automatically install [Powerline fonts](https://github.com/powerline/fonts), as long as [Oh-My-Zsh](https://ohmyz.sh/) if you use Zsh.

# How to install

## Get shellConfig

The first step in the installation process is to get the installer from the Web. This is a shell script that lets you install what you want. In order to execute it, give it the proper rights, using *chmod*, like as follow:
```bash
curl -o install.sh https://raw.githubusercontent.com/guilieb/shellConfig/master/install.sh
chmod +x ./install.sh
```

## Install

Once retrieved, you have the following options:

```bash
USAGE:
        install.sh [-h] [--help]
                   [--libshell]
                   [--oh-my-zsh]
                   [--powerline-fonts]
                   [--shell-config]
                   [--all]

        --libshell: install LibShell in the user's current home directory

        --oh-my-zsh: install Oh-My-ZSH in the user's current home directory. In
                     order to run properly, you must install zsh.

        --powerline-fonts: install powerline fonts for the current user

        --shell-config: install ShellConfig on the system. Implies installing
                        libShell as well. It enables ShellConfig default 
                        configuration (replaces any custom .profile, .bashrc 
                        or .zshrc)

        --all: install libShell, Powerline fonts, ShellConfig and OhMyZsh.
```

## Reload the shell

As it’s an installation process affecting the shell itself, you’re encouraged to reload it manually, using either `source ~/.bashrc` or `source ~/.zshrc`, etc.

## Configure

Even if you can use shellConfig without any configuration, to access its full potential, you’re likely to use the two following commands:
1. **importShellConfigExternalDirectory**: Import and use your own shell scripts directory.
2. **importShellConfigSetupFile**: Use your custom configuration file.

The first one allow you to keep your personnal shell scripts as before. You simply have to call the command with the path containing your scripts. Once done, each time a new shell is loaded, so are your personnal functions and variables located in that directory. Here’s an example of my own:
```bash
importShellConfigExternalDirectory ~/Documents/Informatique/Configuration/Scripts\ externes
```

Then order to benefit from everything in shellConfig, you can also import a shellConfig configuration file. You have an example in this repository, called **shellConfig.conf.example**. Feel free to copy and modify it. You can import it via the **importShellConfigSetupFile** command, giving the path to your file as first argument.
```
importShellConfigSetupFile ~/Documents/Informatique/Configuration/local/shellconfig.vars
```

## Full example

```bash
# get the script
curl -o install.sh https://github.com/guilieb/shellConfig/raw/master/install.sh
chmod +x ./install.sh

# install
./install.sh --all

# setup
importShellConfigSetupFile ~/Documents/Informatique/Configuration/local/shellconfig.vars
importShellConfigExternalDirectory ~/Documents/Informatique/Configuration/Scripts\ externes
```

# How to customize

If you decide to enable shellConfig and change a few things, you can! Keep in mind that the easiest thing is to modify the following files: 
* ~/.bashrc if you use bash;
* ~/.zshrc if you use zsh;
* ~/.shellrc if you want to apply a configuration to both shells
