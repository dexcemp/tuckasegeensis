# Do the alignments

for (( i=1 ; i<=278; i++ )); do 
mafft --thread -4 --op 3 --ep 0.123 --auto Locus${i}.*.unique.fasta > Locus_${i}.aligned.fa; # Run mafft, allowing it to decide best parameters
# The higher gap cost is important in regions with long strings of Ns
# I tried replacing auto with L-INS-i, but runtimes were unacceptable
# Make sure the taxon order is unchanged in mafft output -- this is important for concatenating correctly when there is more than one sample per species present.
done

# Remove high missing data SITES

for (( i=1 ; i<=278; i++ )); do
pxclsq -s Locus_${i}.aligned.fa -p 0.1 > Locus_${i}.90missing.fa
done

# Remove high missing data TAXA

for (( i=1 ; i<=278; i++ )); do
python3 removemissingdatataxa.py Locus_${i}.90missing.fa Locus_${i}.90missing.90taxadropped.fa 0.9
done

# Gene trees for ASTRAL

for (( i=1 ; i<=278; i++ )); do
raxmlHPC-PTHREADS-AVX -f a -m GTRGAMMA -s Locus_${i}.90missing.90taxadropped.fa -n Locus_${i} -x $RANDOM -p $RANDOM -N 100 -T 10
done

# Concatenate alignments

pxcat -s *.90missing.fa -p partition.90missing.txt -o concatenated.90missing.panthertown.fasta

# Reformat partition to look like this (no hashtags):

# GTR+G, name = ###-###
# GTR+G, name = ###-###
# GTR+G, name = ###-###

sed -i 's/DNA/GTR+G/g' partition.90missing.txt

# Remove high missing data TAXA (this time on the concatenated alignment)

python3 removemissingdatataxa.py concatenated.90missing.panthertown.fasta concatenated.90missing.50taxadeleted.panthertown.fasta 0.5


# Run concatenated tree

raxml-ng -all --model partition.90missing.txt --msa concatenated.90missing.50taxadeleted.nickdissertation.fasta --prefix panthertown --seed $RANDOM --tree pars{10} --threads 40

# Generate input files for ASTRAL
# Combine all gene trees into one file
cat RAxML_bipartitions.Locus* > all_gene_trees.tre
# Check that the gene tree count is correct
wc -l all_gene_trees.tre
# Suppress branches with support less than 10 per ASTRAL documentation
nw_ed  all_gene_trees.tre 'i & b<=10' o > all_gene_trees.bs10.tre
# Download newest ASTRAL
git clone https://github.com/smirarab/ASTRAL
unzip ./ASTRAL/Astral*
rm -rf ASTRAL/
cp all_gene_trees.bs10.tre ./Astral/
cd Astral
# Run ASTRAL
java -jar astral.5.7.8.jar -i all_gene_trees.bs10.tre -o astral.panthertown.tre 2> astral.panthertown.tre.log



