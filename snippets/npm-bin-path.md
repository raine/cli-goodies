add npm bin to $PATH

```sh
npm-bin-path() {
  echo "adding `npm bin` to path"
  export PATH=$(npm bin):$PATH
  echo $PATH
}
```

```sh
$ npm-bin-path
adding .../node_modules/.bin to path
```
