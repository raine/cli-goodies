easy gist clone

Clone a gist URL

```sh
gist-clone() {
  gist_id=`echo "$1" | sed -e 's/.*\///g'`
  git clone git@gist.github.com:/$gist_id.git $2
}
```

```sh
gist-clone https://gist.github.com/raine/ef467c47029f1d26c30b dir-name
```
