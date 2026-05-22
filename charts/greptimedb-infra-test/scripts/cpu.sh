echo "\n================== CPU tests =================="
if command -v lscpu >/dev/null 2>&1; then
  lscpu
else
  echo "lscpu not available, reading /proc/cpuinfo directly:"
  cat /proc/cpuinfo
fi
