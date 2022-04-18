
library(ggplot2)
library(ggtext)
library(cowplot)
library(patchwork)

##### 1) Source in expected and predicted relative abundance plots ######
source('Core_plots.R')
#Assign plots a shorter name
p1<-exp_lim 
p2<-pred_lim_core



##### 2) Use Cowplot package to grid plots together #####

plot_grid(p1,p2, ncol=1)

  #If you use p1+p1, nrow=2 itll give you the plots on the top row and blank space on bottom
  plot_grid(p1+p2+p1+p2)#If you had 4 plots it automatically puts it into a grid
  
  #The legend of the bottom plot is bigger, leaving the two plots unaligned. 
  #You can fix this one of two ways: first, use align
  
  plot_grid(p1,p2, align ='v',ncol=1)#using align by vertical you're matching up the vertical axises
  #you can even specify whether you want to align both sides or jsut one
  plot_grid(p1,p2, align ='v',axis='l',ncol=1)#so if you did want to align by the legends rather than the plot axis
  
  #A second way to better align these and make it a little neater with the legend would be
  #to use get_legend. Since both plots have the same legend, might as well just use the one 
  #with more sequence types
  legend<-get_legend(p2)

  plots_col <- plot_grid(
    p1 +theme(legend.position="none") ,#hiding the legends on each plot  
    p2 +theme(legend.position="none"),
    align = 'v',
    ncol = 1
  )
  
  plots_col
  
  # Now add legend back in
  cowplot1<-plot_grid(plots_col, legend, ncol=2,rel_widths = c(0.9,0.1), rel_heights = c(1,.1))
  #ggsave('cowplot1.tiff',cowplot1)

  #Could also put legend on the bottom, horizontally, which in this case doesnt make a ton of difference flipping it horizontally
legend_hoz<-get_legend(p2+ theme(legend.position="bottom", legend.direction="horizontal"))
cowplot2<-plot_grid(plots_col, legend_hoz, ncol=1,rel_widths = c(1,1), rel_heights = c(.7,.3))
#ggsave('cowplot2.tiff',cowplot2, width=8, height=10)

  #To make this a cleaner figure for a manuscript, you can try these additional things:
  #remove x axis ticks, add in figure labels

plots_col2 <- plot_grid(p1 +theme(legend.position="none", 
            axis.text.x = element_blank(),
            axis.title.x = element_blank()),
            p2 +theme(legend.position="none"),
            align = 'v',
            ncol = 1,
            labels=c('A','B'),
            label_size = 18,hjust=0) #default is -0.5, and negative numbers move it to the right on the plot. i wanted to move this a little to the left

  #Add legend back in
cowplot3<-plot_grid(plots_col2, legend, 
                    ncol=2,
                    rel_widths = c(.75,.3))

  # Add a title
title <- ggdraw() + draw_label("Expected vs. Predicted Relative Abundance", fontface='bold', size=18)
plot_grid(title, cowplot3, ncol=1, rel_heights=c(0.1, 1)) # rel_heights values control title margins

###### 3) Create Expected vs Predicted Figure with facet_wrap instead ######

  #In core_plots.R, un-comment the rest of the code and walk through facet_wrap with lim_core. 
#- may only have to facet the first plot

# Facet_wrap is useful if you have one or two variables that each have just a couple of levels, as opposed to facet_grid(),
# which is most useful when you have two discrete variables with many levels, and all combinations of the variables exist in the data.
# The names function is used to assign a value as the name for an object.
# So here I created the vector of labels that I wanted and then assigned the values of relative abundance and sequence type
# to  them so that I can use them in this labeller function.
# With labeler = you have to use this labeller function if you have two variables.
# labeller()can take a function or named character vectors.
# In this case of expected and predicted, I'm wrapping them based on the fact that each plot is going to have
# different relative abundances per genome on the x axis, as well as different sequence types.
# This is why I called the vars as rel_abd and ST - either actual or predicted.
# Facet wrap takes the different levels of the two variables (actual vs predicted rel abd and ST)
# and makes two plots but anchors them by the x axis.

##### 4) Using Cowplot and ggdraw ##### 
  # Read in facet plots
  source('Core_plots.R')
  p3<-limited_genomes_facet_plot
 
  
  # Read in C. diff tree script
  source('Cdiff_tree.R')
  tr<-full_tree
  
  #Make manuscript figure with  facet plot and C. diff tree
  # one option:
  plot_grid(p3, tr,ncol=2,rel_widths = c(0.3,0.7))
  
  # better option: plot legend separately before plotting with tree 
  toprow<-plot_grid(p3+theme(legend.position="none"),
                    legend_hoz,
                    ncol=1,
                    rel_heights = c(0.7,0.3))
  
  plot_grid(toprow, tr,ncol=2,rel_widths = c(0.35,0.65))
  
  #cleaner option: use space filler for different  sized plots
  toprow_null<-plot_grid(toprow,
                         NULL, 
                         ncol=1,
                         rel_heights = c(0.75,0.25))
  facet_tree<-plot_grid(toprow_null, tr,
                        ncol=2,
                        rel_widths  = c(0.4,0.6),
                        labels = c("A","B"))
  
  #Add caption with ggplot::labs
  facet_tree<-plot_grid(toprow_null, 
                        tr + labs(caption="Inaccurate predicitons for nested sequence types")+
                          theme(plot.title = element_text(lineheight = 1.5)),
                        ncol=2,
                        rel_widths  = c(0.4,0.6),
                        labels = c("A","B"))
  
  #ggsave('facet_tree.tiff',facet_tree, width=12, height=12)
  
  #Use ggdraw to position a label 
  ggdraw(facet_tree,xlim = c(0, 1), ylim = c(0, 1), clip = "off")+
    draw_label("C. difficile, sysbio dataset", color = "cadetblue", size = 18)
  
  ggdraw(facet_tree,xlim = c(0, 0.7), ylim = c(0, 1), clip = "off")+
    draw_label("C. difficile, sysbio dataset", color = "cadetblue", size = 18)
  # move position of label on figure
  ggdraw(facet_tree, xlim = c(0, 1), ylim = c(0, 1), clip = "off")+
    draw_label("C. difficile, sysbio dataset", color = "cadetblue", size = 18,
               x=0.2,y=0.2)
 
  # Inset relative abundance plot onto C. diff tree plot.
   ggdraw(tr + theme_half_open(12)) + #don't necessarily need this theme
    draw_plot(p2, .55, .5, .35, .3) +
    draw_plot_label(
      c("A", "B"),
      c(0.1, 0.5),#x coord for both
      c(0.9, 0.9),#y coord for both
      size = 12
    )

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
   pcar1+pcar2+pcar3+pcar4
   
   pcar1/pcar4
   
   pcar1 | pcar2
   
   (pcar1/pcar4) | pcar2
   
   (pcar1/pcar4) | ((pcar2 |pcar1)/pcar1)
   
   pcar1 +pcar2 +pcar3+pcar4 + 
     plot_layout(widths = c(2,1)) 
   
   
   #Inset plots with patchwork 
   
   pcar1 + inset_element(pcar2, left = 0.6, bottom = 0.6, right = 1, top = 1)#give location of outer bound
   pcar1 + inset_element(pcar2, left = 0.6, bottom = 0.6, right = .95, top = 0.95)
  
   #Dealing with multiple legends (rather than using get_legend)
   
   p1a <- ggplot(mtcars) + 
     geom_point(aes(mpg, disp, colour = mpg, size = wt)) + 
     ggtitle('Plot 1a')
   
   p1a | (pcar2 / pcar3)
   
   (p1a | (pcar2 / pcar3))+ plot_layout(guides = 'collect')
   
   #Annotations
   cars<-(p1a | (pcar2 / pcar3))+ plot_layout(guides = 'collect')
   
   cars+plot_annotation(tag_levels='A')
   
   cars+plot_annotation(tag_levels='a')
   
  # Modifications only occur for top plot in the patchwork
   cars * theme(plot.title =element_text(face="bold"))
   cars & theme(plot.title =element_text(face="bold"))
   cars * theme_minimal()
   
   #If you want to modify a patch within 
   cars[[2]] <- cars[[2]] + plot_layout(tag_level = 'new')
   cars + plot_annotation(tag_levels = c('A', '1'))
   

   

