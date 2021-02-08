#!/bin/bash

set -e

export PATH=/usr/local/diamond:/usr/local/bin:/usr/bin

REF_BASENAME=$1
shift
SRA_IDS="$@"

DIR=/nas/sra-data/fasta/current

# ensure the data filesystem is mounted
if [ ! -e /nas/sra-data/fasta ]; then
    echo "ERROR: Data mount is not available!" 1>&2
    exit 1
fi

{

   for SRA_ID in $SRA_IDS; do
   
        echo

        SRA_SOURCE=$DIR/${SRA_ID:0:3}/${SRA_ID:0:6}/${SRA_ID}.fasta.gz
        if [ ! -e $SRA_SOURCE ]; then
            # not found - we should log this better
            echo "WARNING: $SRA_ID not found in data directory - skipping..."
            # empty outputs so that job stageout works
            touch $SRA_ID.m8
            continue
        fi
    
        #bowtie2 -p 1 -q --no-unal -x $REF_BASENAME -U $SRA_SOURCE | samtools view -bS - | samtools sort - $SRA_ID
        
        diamond blastx -f 6 qseqid sseqid pident length mismatch qstart qend sstart send evalue bitscore sseq qseq -d proteins -q $SRA_SOURCE -o $SRA_ID.m8

        echo
        echo
        ls -l 
        echo
        echo    

    done

} 2>&1


