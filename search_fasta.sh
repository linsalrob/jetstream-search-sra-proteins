#!/bin/bash

set -e

export PATH=/usr/local/diamond:/usr/local/bin:/usr/bin

REF_BASENAME=$1
shift
SRA_IDS="$@"

DIR=/nas/sra-data/fasta/current

# ensure the wrangler filesystem is mounted
if [ ! -e $DIR ]; then
    echo "ERROR: Wrangler mount is not available!" 1>&2
    exit 1
fi

{

   for SRA_ID in $SRA_IDS; do
   
        echo

        # check wrangler cache first
        WRANGLER_LOC=$DIR/${SRA_ID:0:3}/${SRA_ID:0:6}/${SRA_ID}.fasta.gz
        if [ -e $WRANGLER_LOC ]; then
            SRA_SOURCE="$WRANGLER_LOC"
            echo "Will read $SRA_ID from $WRANGLER_LOC"
        else
            # not found - we should log this better
            echo "WARNING: $SRA_ID not found on Wrangler - skipping..."
            # empty outputs so that job stageout works
            touch $SRA_ID.m8
            continue 
        fi
    
        
        diamond blastx -f 6 qseqid sseqid pident length mismatch qstart qend sstart send evalue bitscore sseq qseq -d proteins -q $SRA_SOURCE -o $SRA_ID.m8

        echo
        echo
        ls -l 
        echo
        echo    

    done

} 2>&1


