
library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)



            # Read in data: 
            MLST<-read_tsv('good_genomes_with_st_and_clade.tsv')
            MLST<-MLST %>% rename(ref_strain=genome_id)
            MLST$ref_strain =gsub('_SB','', MLST$ref_strain)
              #Relative abundance matrix 
            Limited_core<-read_csv('StrainEst_abundance_matrix_core.csv')
              #Relative abundance matrix
            Core_test<-read_csv('2021-06-02_core_allGenomes_StrainEst_abundance_matrix.csv')


################## Limited_core: 
#The first dataset we're using is a relative abundance matrix of c. diff genomes that 
#contains limited genomes in the reference database and core variants only. 
#We will first simplify the variable names then merge with the MLST dataset. 

                      #remove The column (test strain)  CDIF_SB_388 .
                      Limited_core = subset(Limited_core, select = -c(CDIF_SB_388__aln_sort.bam) )
                      # Change OTU column name and shorten character strings in ref_Strain in core and MLST
                      Limited_core<-Limited_core %>% rename(ref_strain=OTU)
                      Limited_core$ref_strain =gsub('_R1.*','', Limited_core$ref_strain)
                      Limited_core$ref_strain =gsub('_SB','', Limited_core$ref_strain)


                      # Merge with MLST data. Merge by observations that are in both datasets.
                      merged<- inner_join(Limited_core, MLST, by = "ref_strain")
          
                      # Convert into longer data frame
                      longer_merged <- merged %>% pivot_longer(CDIF_SB_70__aln_sort.bam:CDIF_SB_348__aln_sort.bam, names_to = "test_strain", values_to = "rel_abundance")
              
                          # Shorten character strings for each test strain
                      longer_merged$test_strain =gsub('__aln.*','', longer_merged$test_strain)
                      longer_merged$test_strain =gsub('_SB','', longer_merged$test_strain)
          
                      # First filter to exclude non-matches (relative abundance <0)
                      long3<-longer_merged%>%filter(longer_merged$rel_abundance >0)

# 1) Plot predicted relative abundances of each test genome by Sequence Type (ST)
  # Plot with ST fill
  pred_lim_core<-ggplot(long3, aes(fill=ST, y=rel_abundance, x=test_strain)) + xlab("Test Genome") + 
  ylab("Predicted Relative Abundance")+ labs(fill = "ST")+ 
  geom_bar(position="fill", stat="identity")+ 
  theme(axis.text.x = element_text(angle = 45, hjust=1), 
        legend.title = element_text(size = 4), 
        legend.text = element_text(size = 4),
        legend.key.size = unit(0.75, "lines"))+ #point out these adjustments
    guides(shape = guide_legend(override.aes = list(size = 0.5)), 
           color = guide_legend(override.aes = list(size = 0.5)))
  




                        # Create Actual MLST dataset
                          # First subset test genomes from MLST
                        TSvec<-c(long3$test_strain)
                        MLST2<-filter(MLST, ref_strain %in% TSvec)
                          # Make actual rel_abd variable to show expected relative abundance and ST for each test genome
                        MLST2<-MLST2%>%mutate(actual_rel_abd= ST>0)
                        MLST2$actual_rel_abd [MLST2$actual_rel_abd == "true"] <- 1
                          # Rename actual/predicted variables
                        MLST2<-MLST2%>%rename(actual_ST="ST", test_strain="ref_strain")
          
#   #2)Plot Expected Relative Abundance
          exp_lim<-ggplot(MLST2, aes(fill=actual_ST, y=actual_rel_abd, x=test_strain)) + 
            xlab("Test Genome") + 
            ylab("Expected Relative Abundance") + 
            labs(fill= "ST")+
            geom_bar( position= "fill", stat="identity") + 
            theme(axis.text.x = element_text(angle = 45, hjust=1), 
                  legend.title = element_text(size = 4), 
                  legend.text = element_text(size = 4),
                  legend.key.size = unit(0.75, "lines"))+ #point out these adjustments
            guides(shape = guide_legend(override.aes = list(size = 0.5)), 
                   color = guide_legend(override.aes = list(size = 0.5)))

#  3) Facet predicted ST plot with expected ST plot

  #1)Discuss:Merge actual data with predicted data, based on test strain.
# facet_data <-left_join(long3, MLST2, by="test_strain")
# facet_data<-facet_data[order(facet_data$test_strain),]
# 
#  # 2) Discuss: Convert facet_data into longer dataset
# long_fd<-gather(facet_data, "rel_abd", "rel_abd_value", rel_abundance, actual_rel_abd)
# long_fd<-gather(long_fd, "ST", "ST_value", ST, actual_ST)
# long_fd<-long_fd [-c(153:456), ]
# long_fd<-long_fd[order(long_fd$test_strain, long_fd$rel_abd_value),]

#   #3)Discuss:  Assign name to plot with all data
# pl<-ggplot(long_fd, aes(x=test_strain, y=rel_abd_value, fill = ST_value))  +
#   geom_bar(position="fill", stat="identity")+ xlab("Test Genome") +
#   ylab("Relative Abundance") + labs(fill = "ST") +
#   ggtitle("Limited Genomes Core Variants Reference Database") +
#   theme(axis.text.x = element_text(angle = 45, hjust=1, size=10),
#         axis.text.y=element_text(size=10),
#         axis.title = element_text(size=10),
#         legend.key.size = unit(0.75, 'lines'),
#         legend.text=element_text(size=4),
#         strip.text.x = element_text(size = 10),
#         legend.title=element_text(size=4))+
#   guides(shape = guide_legend(override.aes = list(size = 0.5)), 
#          color = guide_legend(override.aes = list(size = 0.5)))
# 


#     4)    DO: Assign names for strip labels
# abd.labs<-c("Expected","Predicted")
# names(abd.labs)<-c("actual_rel_abd", "rel_abundance")
# st.labs<-c("ST","ST")
# names(st.labs)<-c("actual_ST","ST")

#   #5) Using facet_wrap
# limited_genomes_facet_plot<-pl+facet_wrap(vars(rel_abd, ST),
#                                           ncol=1,
#                                           labeller=labeller(rel_abd=abd.labs, ST=st.labs))
# limited_genomes_facet_plot<-pl+facet_wrap(vars(rel_abd, ST),
#                                   ncol=1,
#                                   labeller=labeller(rel_abd=abd.labs, ST=st.labs),
#                                   strip.position = "bottom")+ #play around with strip.position
#   theme(strip.placement="outside", strip.background=element_blank())#play around with themes
#                                   

# #facet_grid example 
# car <- ggplot(mpg, aes(displ, cty)) + geom_point()
# 
# # Use vars() to supply variables from the dataset:
# car + facet_grid(rows = vars(drv))
# 
# mt <- ggplot(mtcars, aes(mpg, wt, colour = factor(cyl))) +
#   geom_point()
# 
# mt + facet_grid(vars(cyl), scales = "free")





############ All genomes core: This second dataset we're using is a relative abundance matrix of c. diff genomes that 
#contains all genomes in the reference database and core variants only. 

                    # Remove The column (test strain)  CDIF_SB_388 .
                    Core_test = subset(Core_test, select = -c(CDIF_SB_388__aln_sort.bam) )
                    #Rename first column (reference strain)
                    Core_test<-Core_test %>% rename(ref_strain=OTU)
                    
                    #Shorten character strings in ref_Strain
                    Core_test$ref_strain =gsub('_R1.*','', Core_test$ref_strain)
                    Core_test$ref_strain =gsub('_SB','', Core_test$ref_strain)
      
      
                    # Merge observations that are in both datasets
                    merged3<- inner_join(Core_test, MLST, by = "ref_strain")
                    # Convert into longer data frame
                    longer_merged3 <- merged3 %>% pivot_longer(CDIF_SB_70__aln_sort.bam:CDIF_SB_348__aln_sort.bam, names_to = "Test Strain", values_to = "Relative Abundances")
      
                    #rename
                    longer_merged3<-longer_merged3 %>% rename(test_strain= "Test Strain")
                    longer_merged3<-longer_merged3 %>% rename(rel_abundance= "Relative Abundances")
                    #shorten strings
                    longer_merged3$test_strain =gsub('__aln.*','', longer_merged3$test_strain)
                    longer_merged3$test_strain =gsub('_SB','', longer_merged3$test_strain)
                    #filter to exclude irrelevant ST/ref strains
                    longer_merged_3<-longer_merged3%>%filter(longer_merged3$rel_abundance >0)
                    


# 1) Plot predicted relative abundance 
   # Make plot with ST fill
   pred_all_core<-ggplot(longer_merged_3, aes(fill=ST, y=rel_abundance, x=test_strain)) + 
     xlab("Test Genome") + ylab("Predicted Relative Abundance")+ 
     labs(fill = "ST")+ geom_bar(position="fill", stat="identity")+ 
     theme(axis.text.x = element_text(angle = 45, hjust=1), 
           legend.title = element_text(size = 4), 
           legend.text = element_text(size = 4),
           legend.key.size = unit(0.75, "lines"))+ #point out these adjustments
     guides(shape = guide_legend(override.aes = list(size = 0.5)), 
            color = guide_legend(override.aes = list(size = 0.5)))



              #Subset test genomes from MLST
              TSvec7<-c(longer_merged_3$test_strain)
              MLST2<-filter(MLST, ref_strain %in% TSvec7)
              #add actual rel_abd
              MLST2<-MLST2%>%mutate(actual_rel_abd= ST>0)
              #Rename actual/predicted variables
              MLST2<-MLST2%>%rename(actual_ST="ST", test_strain="ref_strain")
              MLST2$actual_rel_abd [MLST2$actual_rel_abd == "true"] <- 1

# 2) Plot Expected ST rel_abundance             
exp_all<- ggplot(MLST2, aes(fill=actual_ST, y=actual_rel_abd, x=test_strain)) +
  xlab("Test Genome") +
  ylab("Expected Relative Abundance") + 
  labs(fill="ST")+
  geom_bar( position= "fill", stat="identity") + 
  theme(axis.text.x = element_text(angle = 45, hjust=1), 
        legend.title = element_text(size = 4), 
        legend.text = element_text(size = 4),
        legend.key.size = unit(0.75, "lines"))+ #point out these adjustments
  guides(shape = guide_legend(override.aes = list(size = 0.5)), 
         color = guide_legend(override.aes = list(size = 0.5)))


              # Facet full ST plot with actual ST plot
              # Merge with actual MLST dataset
              h8<-left_join(longer_merged_3, MLST2, by="test_strain")
              h8<-h8[order(h8$test_strain),]
              #gather group_plot into longer dataset
              lh8<-gather(h8, "rel_abd", "rel_abd_value", rel_abundance, actual_rel_abd)
              lh8<-gather(lh8, "ST", "ST_value", ST, actual_ST)
              lh8<-lh8 [-c(283:846), ]
              lh8<-lh8[order(lh8$test_strain, lh8$rel_abd_value),]
#               
# 
# 2) Facet plots together
# p8<-ggplot(lh8, aes(x=test_strain, y=rel_abd_value, fill = ST_value))  +
#   geom_bar(position="fill", stat="identity")+ xlab("Test Genome") + ylab("Relative Abundance") +
#   labs(fill = "Sequence Type") +ggtitle(" All Genomes Core with Test Strains") +
#   theme(axis.text.x = element_text(angle = 45, hjust=1, size=10),
#         axis.text.y=element_text(size=10),
#         axis.title = element_text(size=10),
#         legend.key.size = unit(0.75, 'lines'),
#         legend.text=element_text(size=4),
#         strip.text.x = element_text(size = 10),
#         legend.title=element_text(size=4))+
#   guides(shape = guide_legend(override.aes = list(size = 0.5)), 
#          color = guide_legend(override.aes = list(size = 0.5)))
# 
# all_genomes_facet_plot<-p8+facet_wrap(vars(rel_abd, ST),
#                                       ncol=1,labeller=labeller(rel_abd=abd.labs, ST=st.labs))
# 
# 

