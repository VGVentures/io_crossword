#!/bin/bash

export FB_APP_ID=io-crossword-dev
export GAME_URL=http://localhost:24514
export USE_EMULATOR=false
export INITIALS_BLACKLIST_ID=T1ilfCwjDpLS7iaFzenA
export FB_STORAGE_BUCKET=io-crossword-dev.appspot.com
export HINT_FUNCTION_URL=gethintkit-sea6y22h5q-uc.a.run.app

echo ' ######################## '
echo ' ## Starting dart frog ## '
echo ' ######################## '

dart_frog dev