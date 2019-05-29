#!/bin/bash

awk '{print $NF, $0}' before.log \
  | sed -E 's/\s+$/ /g' \
  | sed -E 's/\s+=>//g' \
  | grep -E '^[0-9.]+s' \
  | sed -E 's/^([0-9.]+)s/\1/' \
  | sort -rnk1 \
  > times.log
