beautify and syntax highlight a JavaScript file

```sh
npm install -g js-beautify
pip install Pygments
```

```sh
jscat() {
  < $1 | js-beautify -s 2 -f - | pygmentize -g | less -F
}
```

```sh
jscat foo.min.js
```
