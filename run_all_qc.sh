#!/usr/bin/env bash

# Χρήση:
#   ./run_all_qc.sh data
#
# Τρέχει fastq_qc.sh για ΟΛΑ τα .fastq αρχεία σε έναν φάκελο.

dir="$1"

if [ -z "$dir" ]; then
  echo "Χρήση: $0 <directory-with-fastq-files>"
  exit 1
fi

if [ ! -d "$dir" ]; then
  echo "Ο φάκελος '$dir' δεν υπάρχει."
  exit 1
fi

for f in "$dir"/*.fastq; do
  if [ -f "$f" ]; then
    echo "====== QC για αρχείο: $f ======"
    ./fastq_qc.sh "$f"
    echo
  fi
done
