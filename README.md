# Luatiny
Reduce the size of your Lua files by removing unnecessary whitespace and compacting the source code.

# Description
Luatiny is a Bash script that uses the **Luamin** tool to minify Lua files in order to reduce their size through the removal of all comments and whitespace from the source code, as well as the renaming of local variable names to a more abbreviated form.

> I created this script with the intention of optimizing Neovim's configuration, but it can be useful for any Lua project that seeks to reduce its size.

## Requirements
To use Luatiny, make sure you have [Luamin](https://github.com/mathiasbynens/luamin) installed:

```bash
npm install luamin
```

## Installation

Follow these steps to install and configure Luatiny:

1. Clone this repository to your local machine:
    ```sh
    git clone https://github.com/farias-hecdin/Luatiny.git
    ```

2. Add this code snippet to your `.zshrc` or `.bashrc` file to be able to execute Lare from any directory.
    ```sh
    # Luatiny
    export LUATINY_HOME="$HOME/.local/share/luatiny"
    export PATH="$LUATINY_HOME:$PATH"
    ```

3. Run the `wizard.sh` file to install Luatiny:
    ```sh
    cd Luatiny/
    bash wizard.sh
    ```

3. Once you have installed Luatiny, you can run the script by typing the following command and specifying a directory:
    ```sh
    luatiny [directory]
    ```

To display the help text, you can use the `luatiny --help` command.

## License
Luatiny is under the MIT license. See the `LICENSE` file for more information
