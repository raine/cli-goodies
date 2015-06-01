trim empty area around an image

```sh
trim-empty() {
  convert "$1" -fuzz "1%" -trim +repage "$1"
}
```

```sh
trim-empty img.png
```

[Use ImageMagick to trim empty around an image](https://coderwall.com/p/1shzpw/use-imagemagick-to-trim-empty-around-an-image)
