#! /usr/bin/env python
import screed
import sys
import random
import fasta

random.seed(1)                  # make this reproducible, please.

COVERAGE=50
READLEN=100
ERROR_RATE=100

record = iter(screed.open(sys.argv[1])).next()
genome = record.sequence
len_genome = len(genome)

n_reads = int(len_genome*COVERAGE / float(READLEN))
reads_mut = 0
total_mut = 0

position_fp = open('biased-random-positions.out', 'w')

for i in range(n_reads):
    start = random.randint(0, len_genome - READLEN)
    read = genome[start:start + READLEN].upper()

    # reverse complement?
    if random.choice([0, 1]) == 0:
        read = fasta.rc(read)

    # error?
    was_mut = False
    for _ in range(READLEN):
        while random.randint(1, ERROR_RATE) == 1:
            fake_end = int(READLEN*1.5)
            pos = random.randint(1, fake_end) - 1
            if pos >= READLEN:
                pos -= int(0.5 * READLEN)
            read = read[:pos] + random.choice(['a', 'c', 'g', 't']) + read[pos+1:]
            was_mut = True
            total_mut += 1

            print >>position_fp, pos

    if was_mut:
        reads_mut += 1
    
    print '>read%d\n%s' % (i, read)

print >>sys.stderr, "%d of %d reads mutated; %d total mutations" % \
    (reads_mut, n_reads, total_mut)
