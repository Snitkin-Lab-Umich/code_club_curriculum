
library(ggplot2)
library(cowplot)
library(patchwork)

#1) Source in expected and predicted relative abundance plots 
source('Tutorial_core_plots.R')




# 2) Use Cowplot package to grid plots together 



  # The legend of the bottom plot is bigger, leaving the two plots unaligned. 
  # You can fix this one of two ways: first, use align
  
  
  #A second way to better align these and make it a little neater with the legend would be
  #to use get_legend. Since both plots have the same legend, might as well just use the one 
  #showing all potential sequence types
 
legend<-
  
plots_row<- plot_grid()

cowplot1<-
#ggsave('cowplot1.tiff',cowplot1)
  
  #Could also put legend on the bottom, horizontally, which in this case doesn't make a ton of difference.
legend_hoz<-get_legend(p2+ theme())
cowplot2<-plot_grid(plots_row, legend_hoz)
#ggsave('cowplot2.tiff',cowplot2)

  #To make this a cleaner figure for a manuscript, you can try these additional things:
  #remove x axis ticks, add in figure labels

plots_col2 <- plot_grid(p1 +theme(legend.position="none"), 
                        p2 +theme(legend.position="none"),
                        align = 'v',
                        ncol = 1)
                        
cowplot3<-plot_grid(plots_col2, legend, 
                    ncol=2,
                    rel_widths = c(.75,.25), 
                    rel_heights = c(1,.1))

# Add a title using ggdraw
title <- 
  
  
###### 3) Create Expected vs Predicted Figure with facet_wrap instead ######

#In core_plots.R, un-comment the rest of the code and walk through facet_wrap with lim_core. 

# Facet_wrap is useful if you have one or two variables that each have just a couple of levels, as opposed to facet_grid(),
# which is most useful when you have two discrete variables with many levels, and all combinations of the variables exist in the data.
# The names function is used to assign a value as the name for an object.


##### 4) Using Cowplot and ggdraw ##### 
  # Read in facet plots
  source('Tutorial_core_plots.R')
  p3<-limited_genomes_facet_plot
  
  
  # Read in C. diff tree script
  source('Cdiff_tree.R')
  tr<-full_tree
  
  #Make manuscript figure with  facet plot and C. diff tree
  # one option:
  plot_grid()
  
  # better option: plot legend separately before plotting with tree 
  toprow<-plot_grid()
  
  plot_grid()

  #cleaner option: use space filler for different  sized plots
  toprow_null<-plot_grid()
  
  facet_tree<-plot_grid()
  
  #Add caption with ggplot::labs
  facet_tree<-plot_grid()

#ggsave('facet_tree.tiff',facet_tree, width=12, height=12)

  #Use ggdraw to position a label 
  ggdraw()+
    draw_label()
  
  ggdraw()+
    draw_label()
  #move position
  ggdraw()+
    draw_label()

  #Make inset plot
  ggdraw() + 
    draw_plot() +
    draw_plot_label()

##### 5) Patchwork #####
  #using mtcars plots
  pcar1 <- ggplot(mtcars) + 
    geom_point(aes(mpg, disp)) + 
    ggtitle('Plot 1')
  
  pcar2 <- ggplot(mtcars) + 
    geom_boxplot(aes(gear, disp, group = gear)) + 
    ggtitle('Plot 2')
  
  pcar3 <- ggplot(mtcars) + 
    geom_point(aes(hp, wt, colour = mpg)) + 
    ggtitle('Plot 3')
  
  pcar4 <- ggplot(mtcars) + 
    geom_bar(aes(gear)) + 
    facet_wrap(~cyl) + 
    ggtitle('Plot 4')
  
  # Learning the symbols
  

  
  
  
  
  
  #Inset plots with patchwork 
  
  pcar1 + inset_element()# these give location of outer bound
  pcar1 + inset_element()
  
  #Dealing wtih multiple legends


  
  
  

  #Annotations
  
  
  # Modifications only occur for top plot in the patchwork
  
  
  
  
  #If you want to modify a patch within 
  








