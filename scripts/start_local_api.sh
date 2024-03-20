#!/bin/bash

export FB_APP_ID=io-crossword-dev
export GAME_URL=http://localhost:24514
export USE_EMULATOR=false
export ENCRYPTION_KEY=X9YTchZdcnyZTNBSBgzj29p7RMBAIubD
export ENCRYPTION_IV=FxC21ctRg9SgiXuZ
export INITIALS_BLACKLIST_ID=T1ilfCwjDpLS7iaFzenA
export FB_STORAGE_BUCKET=io-crossword-dev.appspot.com

echo ' ######################## '
echo ' ## Starting dart frog ## '
echo ' ######################## '

cd api && dart_frog dev