#!/usr/bin/env bash

# Χρήση:
#   bash fastq_qc.sh sample1.fastq

file="$1"

if [ -z "$file" ]; then
  echo "Χρήση: bash fastq_qc.sh <fastq-file>"
  exit 1
fi

if [ ! -f "$file" ]; then
  echo "Το αρχείο '$file' δεν βρέθηκε."
  exit 1
fi

echo "=== FASTQ QC REPORT ==="
echo "Αρχείο: $file"

# 1) Σύνολο γραμμών
total_lines=$(wc -l < "$file")
echo "Σύνολο γραμμών: $total_lines"

# 2) Υπολογισμός reads (4 γραμμές ανά read)
read_count=$(( total_lines / 4 ))
echo "Σύνολο reads: $read_count"

# 3) Υπολογισμός μέσου μήκους read
# Παίρνουμε όλες τις sequence lines (γραμμή 2 κάθε 4) με sed
# Μετά μετράμε το μήκος κάθε γραμμής και τα προσθέτουμε

if [ "$read_count" -gt 0 ]; then
  total_len=0
  while read -r seq; do
    len=${#seq}
    total_len=$(( total_len + len ))
  done < <(sed -n '2~4p' "$file")

  avg_len=$(( total_len / read_count ))

  echo "Συνολικό μήκος βάσεων (όλων των reads): $total_len"
  echo "Μέσο μήκος read: $avg_len"
fi

echo "=== ΤΕΛΟΣ ΑΝΑΦΟΡΑΣ ==="
