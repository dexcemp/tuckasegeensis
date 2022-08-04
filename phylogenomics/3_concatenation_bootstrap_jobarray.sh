#!/bin/bash
#$ -N rax_bootstrap # Job name
#$ -cwd # Run in current directory
#$ -pe smp 36 # processor
#$ -l h_vmem=1G # 8 gigabytes per processor
#$ -l s_rt=200:00:00 # Soft time limit
#$ -l h_rt=200:00:00 # Hard time limit
#$ -M rfolk@biology.msstate.edu
#$ -m ea
#$ -o raxml.log
#$ -e raxml.err
#$ -t 1-100

module load /mnt/opt_lugh/modules/Biology/RAxML-ng/0.9.0

raxml-ng -bootstrap --model partition.90missing.txt --msa concatenated.90missing.panthertown.fasta --prefix bootstrap_${SGE_TASK_ID} --seed $RANDOM --bs-trees 1 --threads 36
