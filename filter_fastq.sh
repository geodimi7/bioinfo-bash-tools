#!/usr/bin/env bash

# Χρήση:
#   ./filter_fastq.sh input.fastq MOTIF
#
# Παράδειγμα:
#   ./filter_fastq.sh sample1.fastq ACGT

file="$1"
motif="$2"

if [ -z "$file" ] || [ -z "$motif" ]; then
  echo "Χρήση: $0 <fastq-file> <motif>"
  exit 1
fi

if [ ! -f "$file" ]; then
  echo "Το αρχείο '$file' δεν βρέθηκε."
  exit 1
fi

output="filtered_${motif}.fastq"

echo "Φιλτράρω reads στο '$file' με motif '$motif'..."
echo "Αποτέλεσμα θα γραφτεί στο: $output"

# Διαβάζουμε το FASTQ σε blocks των 4 γραμμών με awk
awk -v motif="$motif" '
  NR % 4 == 1 {h=$0}      # header
  NR % 4 == 2 {s=$0}      # sequence
  NR % 4 == 3 {p=$0}      # plus line
  NR % 4 == 0 {q=$0       # quality
    if (s ~ motif) {
      print h ORS s ORS p ORS q
    }
  }
' "$file" > "$output"

echo "Τέλος. Δες το αρχείο: $output"
