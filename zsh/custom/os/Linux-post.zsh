export MAKEFLAGS="-j$(cat /proc/cpuinfo | grep processor | wc -l)"
