# Heuchera tuckasegeensis description

## Morphometrics folder

* `morphometrics.r` 
R script for morphometric analysis.
 
* `parviflora_ryancleaned_2022.csv`
Raw morphometric data.

## Phylogenomics folder (run numbered scripts in order)
* `1_panthertown_project_selector.sh
Script to fetch raw aTRAM assemblies and filter duplicate accessions.

* `2_align_then_genetrees_concatenation_ASTRAL.sh
Script to align gene trees, run ASTRAL, and perform concatenation.

* `3_concatenation_bootstrap_jobarray.sh
Script to perform concatenated analysis.

* `all_gene_trees.tre
Gene trees.

* `all_gene_trees.bs10.tre
Gene trees, branches with BS support < 10 collapsed.

* `astral.panthertown.tre
ASTRAL result.

* `concatenated.90missing.panthertown.fasta
Concatenated matrix.

* `partition.90missing.txt
Partition file for concatenated matrix.

* `panthertown.raxml.support
RAxML-NG result.
