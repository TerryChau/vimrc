# .vimrc

This repository stores my .vimrc script.  This script enables many of the keyboard shortcut common to most text editors, and allows a user to stay in `insert` mode longer.  This script also enables many of vim's built-in autocomplete features, as well as the autocomplete features from ALE for C/C++, python, java, javascript, typescript, html and css.

## Installation

Place this file in `/home/user/.vimrc`.

Then run

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim

:PlugInstall<Enter>
```

To complete install, install separately on the system the following:

- python language system
- typescript
- htmlhint
- styleint
- eslint
- prettier
- clang
- java-language-server
- xdotool
- ctags

Installation instructions for these packages differ based on the operating system.

## Usage

More information will be added here.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)