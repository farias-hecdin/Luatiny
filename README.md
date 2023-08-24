# Luatiny

Reduce the size of your Lua files by removing unnecessary whitespace and compacting the source code.

# Description

> This script was created with the motivation of optimizing Neovim's configuration, but it can be useful for any Lua project that seeks to reduce its size.

Luatiny is a Bash script that uses the **Luamin** tool to minify Lua files in order to reduce their size through the removal of all comments and whitespace from the source code, as well as the renaming of local variable names to a more abbreviated form.

## Requirements

To use Luatiny, make sure you have [Luamin](https://github.com/mathiasbynens/luamin) installed:

```bash
npm install luamin
```

## Installation

Follow these steps to install and configure Luatiny:

1. Clone this repository to your local machine:

```bash
git clone https://github.com/farias-hecdin/Luatiny.git
```

1. Run the `wizard.sh` file to install Luatiny:

```bash
cd Luatiny/
bash wizard.sh
```

3. Once you have installed Luatiny, you can run the script by typing the following command and specifying a directory:

```bash
luatiny [directory]
```

4. Follow the on-screen instructions to minify your Lua files.

## License

Luatiny is under the MIT license. See the `LICENSE` file for more information
