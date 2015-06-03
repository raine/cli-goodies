use `diff` to compare files changed by a command

No temporary files

```sh
old=$(cat l10n/*.json); localize; diff <(echo -E "$old") <(cat l10n/*.json)
```
