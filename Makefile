all: genome.fa reads-nobias.fa reads-bias-nonrandom.fa reads-bias-nonrandom.fa \
	metag-reads.fa reads-bias-nonrandom.dens  reads-bias-random.dens  reads-nobias.dens reads-bias-random.r1.dens reads-bias-random.r3.dens reads-bias-random.r5.dens repreads-bias-random.dens

genome.fa:
	python make-random-genome.py > genome.fa

repgenome.fa:
	python make-random-genome-with-repeats.py > repgenome.fa

reads-nobias.fa: genome.fa
	python make-reads.py genome.fa > reads-nobias.fa

reads-bias-random.fa: genome.fa
	python make-reads-biased-random.py genome.fa > reads-bias-random.fa

repreads-bias-random.fa: repgenome.fa
	python make-reads-biased-random.py repgenome.fa > repreads-bias-random.fa

reads-bias-nonrandom.fa: genome.fa
	python make-reads-biased-nonrandom.py genome.fa > reads-bias-nonrandom.fa

transcripts.fa:
	python make-random-transcriptome.py > transcripts.fa

metag-reads.fa: transcripts.fa
	python make-biased-reads.py transcripts.fa > metag-reads.fa

reads-nobias.ht: reads-nobias.fa
	python /u/t/dev/khmer/scripts/load-graph.py -k 32 -N 4 -x 1e9 --no-build-tagset reads-nobias reads-nobias.fa

reads-nobias.dens: reads-nobias.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -n 10000 reads-nobias.ht reads-nobias.fa reads-nobias.dens

reads-bias-random.ht: reads-bias-random.fa
	python /u/t/dev/khmer/scripts/load-graph.py -k 32 -N 4 -x 1e9 --no-build-tagset reads-bias-random reads-bias-random.fa

reads-bias-random.dens: reads-bias-random.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -n 10000 reads-bias-random.ht reads-bias-random.fa reads-bias-random.dens

reads-bias-random.r1.dens: reads-bias-random.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -r 1 -n 10000 reads-bias-random.ht reads-bias-random.fa reads-bias-random.r1.dens

reads-bias-random.r3.dens: reads-bias-random.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -r 3 -n 10000 reads-bias-random.ht reads-bias-random.fa reads-bias-random.r3.dens

reads-bias-random.r5.dens: reads-bias-random.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -r 5 -n 10000 reads-bias-random.ht reads-bias-random.fa reads-bias-random.r5.dens

reads-bias-nonrandom.ht: reads-bias-nonrandom.fa
	python /u/t/dev/khmer/scripts/load-graph.py -k 32 -N 4 -x 1e9 --no-build-tagset reads-bias-nonrandom reads-bias-nonrandom.fa

reads-bias-nonrandom.dens: reads-bias-nonrandom.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -n 10000 reads-bias-nonrandom.ht reads-bias-nonrandom.fa reads-bias-nonrandom.dens

repreads-bias-random.ht: repreads-bias-random.fa
	python /u/t/dev/khmer/scripts/load-graph.py -k 32 -N 4 -x 1e9 --no-build-tagset repreads-bias-random repreads-bias-random.fa

repreads-bias-random.dens: repreads-bias-random.ht
	python /u/t/dev/khmer/sandbox/count-density-by-position.py -n 10000 repreads-bias-random.ht repreads-bias-random.fa repreads-bias-random.dens