#!/bin/bash

cd script_dir=$(dirname "$(realpath "$0")")
cd "$script_dir"
cd ..

cp githooks/commit-msg .git/hooks/commit-msg

chmod +x .git/hooks/commit-msg
