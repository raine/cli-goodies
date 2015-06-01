#!/usr/bin/env bash

find snippets -name '*.md' | R -sr \
  'map read-file' \
  'map (lines >> (-> ["## " + it.0] ++ tail it) >> unlines)' \
  'unlines' \
  '-> snippets: it' |\
  tmpl README.tmpl.md > README.md

doctoc --title '# cli-goodies' README.md
