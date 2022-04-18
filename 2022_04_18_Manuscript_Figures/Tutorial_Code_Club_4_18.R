
library(ggplot2)
library(cowplot)
library(patchwork)
library(ggtext)

#1) Source in expected and predicted relative abundance plots 
#add library(ggtext)
source('Tutorial_core_plots.R')
p1<-exp_lim
p2<-pred_lim_core



# 2) Use Cowplot package to grid plots together 

plot_grid(p1+p2+p1+p2)

plot_grid(p1,p2,align='v',ncol = 1)

  # The legend of the bottom plot is bigger, leaving the two plots unaligned. 
  # You can fix this one of two ways: first, use align
  
  
  #A second way to better align these and make it a little neater with the legend would be
  #to use get_legend. Since both plots have the same legend, might as well just use the one 
  #showing all potential sequence types
 
legend<-get_legend(p2)
  
plots_col<- plot_grid(
  p1+theme(legend.position="none"),
  p2+theme(legend.position = "none"),
  align='v',
  ncol=1)
)



cowplot1<-plot_grid(plots_col, legend, ncol=2, rel_widths = c(0.9,0.1), rel_heights = c(1, 0.1))
#ggsave('cowplot1.tiff',cowplot1)
  
  #Could also put legend on the bottom, horizontally, which in this case doesn't make a ton of difference.
legend_hoz<-get_legend(p2+ theme(legend.position = "bottom",
                                 legend.direction = "horizontal"))
cowplot2<-plot_grid(plots_col, legend_hoz, ncol=1, rel_heights = c(0.7, 0.3))
#ggsave('cowplot2.tiff',cowplot2)

  #To make this a cleaner figure for a manuscript, you can try these additional things:
  #remove x axis ticks, add in figure labels

plots_col2 <- plot_grid(p1 +theme(legend.position="none",
                        axis.text.x=element_blank(),
                        axis.title.x=element_blank()),
                        p2 +theme(legend.position="none"),
                        align = 'v',
                        axis='l',
                        ncol = 1,
                        labels=c('A','B'),
                        label_size=18, hjust=0)
                        
cowplot3<-plot_grid(plots_col2, legend, 
                    ncol=2,
                    rel_widths = c(.75,.25), 
                    rel_heights = c(1,.1))

# Add a title using ggdraw
title <- ggdraw()+draw_label("Expected vs Predicted Relative Abundance",fontface='bold',size=18)
plot_grid(title,cowplot3, ncol=1, rel_heights = c(0.1,1))
  
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
  plot_grid(p3, tr, ncol=2, rel_widths = c(0.3,0.7))
  
  # better option: plot legend separately before plotting with tree 
  toprow<-plot_grid(p3+theme(legend.position = "none"),
                    legend_hoz,
                    NULL,
                    ncol=1,
                    rel_heights = c(0.7,0.2,.3))
  
  plot_grid(toprow+labs(caption = "Inaccurate predictions"), tr, ncol=2, rel_widths = c(0.35,0.65))

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
  pcar1+pcar2+pcar3+pcar4 +plot_layout(widths=c(2,1))
  
  pcar1/pcar4
  
  pcar1 | pcar2
  
  (pcar1/pcar4)|(pcar2|pcar1)/pcar1
  
  
  
  

  
  
  
  
  
  #Inset plots with patchwork 
  
  pcar1 + inset_element(pcar2,left=0.6,bottom = 0.6,right = .95,top=.95)# these give location of outer bound
  pcar1 + inset_element()
  
  #Dealing wtih multiple legends

p1a<-ggplot(mtcars)+
  geom_point(aes(mpg,disp,colour=mpg,size=wt))+
  ggtitle('Plot 1a')

(p1a | (pcar2/pcar3)) +plot_layout(guides='collect')
  
  
  

  #Annotations
  
  
  # Modifications only occur for top plot in the patchwork
  cars<-(p1a | (pcar2/pcar3))+plot_layout(guides='collect')
  
  
  
  #If you want to modify a patch within 
  cars * theme(plot.title=element_text(face="bold"))
  








