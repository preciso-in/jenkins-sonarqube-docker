#!/bin/bash

cd ..

cp githooks/commit-msg .git/hooks/commit-msg

chmod +x .git/hooks/commit-msg
