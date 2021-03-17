# vim-reveal

DEPRECATED in favor of [coc-reveal](https://github.com/gera2ld/coc-reveal).

vim plugin that use markdown and reveal.js to generate presentations.

This plugin is based on [blindFS/vim-reveal](https://github.com/blindFS/vim-reveal) with the following features:

- Load reveal.js from CDN by default.
- Map H1 and H2 headings to horizontal and vertical slides, respectively.
- Generate an HTML in the directory of the Markdown file, with the same basename.

## Installation

* Whatever the package managing plugin you are using.
* Configuration

## Vim configuration

```vim
let g:reveal_config = {
    \'root_path': 'https://cdn.jsdelivr.net/npm/reveal.js',
    \'key1': 'value1',
    \'key2': 'value2',
    \ ...}                                     " Default options for reveal.js.
```

## Syntax

Besides default markdown syntax, you need something else to specify the sections each of which will take care of a single
page in the final presentation.
And you need something to customize the reveal.js options.

```
<!--Meta key1:value1 key2:value2 [...]--> // Options,these lines should be in the head of the file.
```

## Generate the html file

Use the `:RevealIt` command to generate the html file.
