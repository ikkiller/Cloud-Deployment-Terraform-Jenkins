#!/bin/bash
echo "Running dummy tests..."
# a very small "test" that always passes
if [ 2 -eq 2 ]; then
  echo "Dummy test passed"
  exit 0
else
  echo "Dummy test failed"
  exit 1
fi
