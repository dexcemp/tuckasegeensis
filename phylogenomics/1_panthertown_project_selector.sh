# CHECK THAT ALL PANTHERTOWN SEQUENCES ARE INCLUDED

for file in *.Final.Contigs.fasta; do
echo $file

# Panthertown
grep -P -A 1 ">H230-.*$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1932$" $file >> $file.panthertown.fasta

# Other parviflora group North and South Carolina and Georgia
grep -P -A 1 ">H97-6$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H229-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H231-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H232-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E554$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1437$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1439$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1440$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1591$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1930$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1931$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1933$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1934$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E1935$" $file >> $file.panthertown.fasta

# Villosa
grep -P -A 1 ">A5-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">A12-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">A30-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H73$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H75-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H78-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H90-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H91-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H93-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H94-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H192-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H194-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">I1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">I61$" $file >> $file.panthertown.fasta
grep -P -A 1 ">I184$" $file >> $file.panthertown.fasta
grep -P -A 1 ">E26$" $file >> $file.panthertown.fasta

# Puberula
grep -P -A 1 ">H69-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H188-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H189-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H222-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">I86$" $file >> $file.panthertown.fasta

# Parviflora
grep -P -A 1 ">H80-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">170-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H200-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H204-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H215-1$" $file >> $file.panthertown.fasta

# Missouriensis
grep -P -A 1 ">H172-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">H213-1$" $file >> $file.panthertown.fasta
grep -P -A 1 ">I66$" $file >> $file.panthertown.fasta
grep -P -A 1 ">I69$" $file >> $file.panthertown.fasta

# Outgroups
#Heuchera soltisii 
grep -P -A 1 ">I85$" $file >> $file.panthertown.fasta
#Heuchera parvifolia 
grep -P -A 1 ">I56$" $file >> $file.panthertown.fasta
#Heuchera merriamii 
grep -P -A 1 ">H150-1$" $file >> $file.panthertown.fasta
#Heuchera woodsiaphila 
grep -P -A 1 ">H23-1$" $file >> $file.panthertown.fasta
#Heuchera richardsonii 
grep -P -A 1 ">A21-1$" $file >> $file.panthertown.fasta
#Heuchera caroliniana 
grep -P -A 1 ">H216-1$" $file >> $file.panthertown.fasta
#Heuchera pubescens 
grep -P -A 1 ">H96-1$" $file >> $file.panthertown.fasta

done


# Remove bad samples

sed -i '/E554$/,+1d' *.panthertown.fasta  # Poor assembly

# Second dataset with two more samples removed
for f in *.panthertown.fasta; do
sed '/E1932$/,+1d' $f > $f.reduced  # Poor assembly
done
sed -i '/E1933$/,+1d' *.reduced  # Poor assembly


# Count total samples
grep --no-filename ">" Locus*.Final.Contigs.fasta.panthertown.fasta | sort | uniq | wc -l



# Detect duplicates (loci > 277) and bad samples (loci << 277) by enumerating loci per sample
for g in `grep --no-filename ">" Locus*.Final.Contigs.fasta.panthertown.fasta | sort | uniq`; do 
echo $g; 
grep -P "${g}\$" *.panthertown.fasta | wc -l;  
done

# Remove any duplicates, taking the last occurrence (redo last assuming folders sort correctly, using tac and taking the first), noting $1 is column 1 for comparing names and not sequences
for f in *.panthertown.fasta; do
cat $f | tr '\n' '\t' | sed 's/\t>/\n>/g' | tac | awk '! seen[$1]++' | tac | sed 's/\t/\n/g' | sed '/^--$/d' > ${f}.unique.fasta
done

for f in *.reduced; do
cat $f | tr '\n' '\t' | sed 's/\t>/\n>/g' | tac | awk '! seen[$1]++' | tac | sed 's/\t/\n/g' | sed '/^--$/d' > ${f}.unique.fasta
done


# Detect duplicates (loci > 277) and bad samples (loci << 277) by enumerating loci per sample, counting unique files and generating a count file this time
for f in `grep --no-filename ">" *.panthertown.fasta | sort | uniq`; do 
echo $f >> AAA_counts.txt; 
grep -P "$f$" *fasta.unique.fasta | wc -l >> AAA_counts.txt; 
done
