#!/bin/bash

cat >.git/hooks/commit-msg <<EOF
#!/bin/bash
.githooks/commit-msg
EOF

chmod +x .git/hooks/commit-msg
