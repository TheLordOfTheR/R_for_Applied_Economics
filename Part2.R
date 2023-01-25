# chunk 1
# packages
#install.packages("ggplot2")
#install.packages("scales")
#install.packages("zoo")
library(ggplot2) # for beautiful charts
library(scales) # for beautiful scaling
library(zoo) # for moving average function

# chunk 2 - examples with test data 

# general approach to creation of plots
# ggplot(data, aes(x, y)) + geom_type()

# demonstration on test data 1 
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

# demonstration on test data 2
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_line()

# demonstration on test data 3
ggplot(mpg, aes(x = class)) +
  geom_bar()

# demonstration on test data 4
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  xlab("Engine Displacement") +
  ylab("Highway Miles per Gallon")

# demonstration on test data 5
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  xlab("Engine Displacement") +
  ylab("Highway Miles per Gallon")+
  ggtitle("Scatter plot of Engine Displacement vs Highway Miles per Gallon")

# demonstration on test data 6
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  xlab("Engine Displacement") +
  ylab("Highway Miles per Gallon")+
  ggtitle("Scatter plot of Engine Displacement vs Highway Miles per Gallon")+
  theme(panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "white"))

# demonstration on test data 7
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  xlab("Engine Displacement") +
  ylab("Highway Miles per Gallon")+
  ggtitle("Scatter plot of Engine Displacement vs Highway Miles per Gallon")+
  theme(panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "white"))+
  scale_y_log10()

# demonstration on test data 8
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

# chunk 3
# I assume that you have data from part 1 in your R environment
# if not - please run this code to import code from GitHub
library(devtools) # <<< if you don't have it - you know what to do: install.packages("packagename")
source_url("https://raw.githubusercontent.com/TheLordOfTheR/R_for_Applied_Economics/main/Part1.R")

# this action will make our code more explicit: let's put clean_df into a new df object
df <- clean_df

# here we start our basic plot BUT we add one by one layers on 
# top of that plot so we can gradually check the output

ggplot(df, aes(x = Period, y = Inflation)) +
  geom_line(aes(color = "Inflation"), show.legend = F, size = 0.8) + 
  theme_bw() + 
  xlab('Period of observation') + 
  ylab('Inflation rate, %') + 
  ggtitle("Inflation in European Union") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_breaks = "6 months",
               date_labels = "%b %y",
               expand = c(0.01,0.01)) + 
  scale_y_continuous(breaks=c(seq(0,max(df$Inflation),1)))

# here we add some story
ggplot(df, aes(x = Period, y = Inflation)) +
  geom_line(aes(color = "Inflation"), #show.legend = F,
            size = 0.8) + 
  theme_bw() + 
  xlab('Period of observation') + 
  ylab('Inflation rate, %') + 
  ggtitle("Inflation in European Union") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_breaks = "6 months",
               date_labels = "%b %y",
               expand = c(0.01,0.01)) + 
  scale_y_continuous(breaks=c(seq(0,max(df$Inflation),1))) +
  geom_hline(aes(yintercept=2, color = "Target threshold 2%"),
                size=1) + 
  geom_line(aes(y=rollmean(Inflation, 12, na.pad=TRUE), color = "MA(12)"),
            show.legend = TRUE) + 
  theme(plot.title = element_text(hjust = 0.5),
        text=element_text(size=12,family="Comic Sans MS")) + 
  theme(legend.position="top") + 
  scale_color_manual(name = "",
                     values = c("black", "blue", "red"),
                     labels = c("Inflation", "MA(12)", "Target 2%"))

