#!/bin/bash

export FB_APP_ID=io-crossword-dev
export GAME_URL=http://localhost:24514
export USE_EMULATOR=false
export INITIALS_BLACKLIST_ID=T1ilfCwjDpLS7iaFzenA
export FB_STORAGE_BUCKET=io-crossword-dev.appspot.com
export GEMINI_API_KEY=$GEMINI_API_KEY
export GEMINI_MODEL=gemini-pro

echo ' ######################## '
echo ' ## Starting dart frog ## '
echo ' ######################## '

cd api && dart_frog dev