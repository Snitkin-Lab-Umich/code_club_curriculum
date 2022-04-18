
  
library(tidyverse)
library(tidyr)
library(tidytree)
library(ape)
library(phytools)
library(ggplot2)
library(ggtree)
library(ggheatmap)

 

### All Reference Strains Included
 
cdtree<-read.tree('2020_12_23_18_42_50_cdiff_630_reduced_no_underscores_good_genomes_core.treefile')
cdtree$tip.label=gsub('_SB',"",cdtree$tip.label)
cdtree<-midpoint.root(cdtree)
do_merge<-read_tsv('do_merge.tsv')
mlst<-read_tsv('good_genomes_with_st_and_clade.tsv')
mlst$genome_id=gsub('_SB',"", mlst$genome_id)

# metadata(all ref strains)
longer_merged_3<-read_tsv('longer_merged_3.tsv')
vec_strains<-c(longer_merged_3$ref_strain) #read this in as tsv
cdtree<-keep.tip(cdtree, vec_strains)

#Plot tree to highlight ST and clade 
treeplot<-ggtree(cdtree)
tree_merge_ST<- treeplot %<+% mlst

#all ref strains included
tree_merge_ST+geom_tippoint(aes(color=ST))+geom_tiplab(size=1.5)
full_tree<-tree_merge_ST+geom_tippoint(aes(color=ST))+geom_tiplab(size=2)



 


 
 

