library(dplyr)
library(Hmisc)
library(xtable)
library(glmnet)
library(MASS)
library(car)
library(ggpubr)

getwd()
setwd('/Users/jiatong/Documents/Thesis Project/Data/ODiN 2019')

# load odin data and subsetted by city odin data
df <- read.csv('~/Air Pollution Project/Data/ODiN2019_data.csv', sep = ';')
ams <- read.csv('~/Air Pollution Project/amsterdamtrips.csv', sep = ';')
utr <- read.csv('~/Air Pollution Project/utrechttrips.csv', sep = ';')

# Dataframe descriptives
hist(ams$Hvm, xlab = 'Mode of transport', main = 'Frequencies of transport types',
     names= c('Residential', 'Mobility'), 
     ylab = 'Frequency',
     las = 2)

ggplot(ams, aes(x = Reisduur)) +
  geom_histogram(bins = 10) +
  xlab('Journey duration (mins)') +
  ylab('Frequency')

# number of unique journeys
hist(table(ams$OPID))
hist(table(utr$OPID))

# outliers for journey duration
summary(ams$Reisduur)
3*sd(ams$Reisduur)

ams[ams$Reisduur > 160, ]
tmp <- utr[utr$Reisduur > 160, ]

boxplot(ams$Reisduur)

# Amsterdam Mobility Data
ams_car_stats <- read.csv("~/Air Pollution Project/Processed Data/ams_cars_stats.csv")
ams_walk_stats <- read.csv("~/Air Pollution Project/Processed Data/ams_walk_stats.csv")
ams_bike_stats <- read.csv("~/Air Pollution Project/Processed Data/ams_bikes_stats.csv")

# Amsterdam Residential Data
ams_res <- read.csv("~/Air Pollution Project/Processed Data/res_no2_ams_avg.csv")
ams_rivm <- read.csv("~/Air Pollution Project/Processed Data/res_no2_rivm.csv")

# Utrecht Mobility Data
utr_car <-read.csv("~/Air Pollution Project/Processed Data/utr_car.csv")
utr_bike <-read.csv("~/Air Pollution Project/Processed Data/utr_bike.csv")
utr_walk <-read.csv("~/Air Pollution Project/Processed Data/utr_walk.csv")

# Utrecht Residential Data
utr_res <-read.csv("~/Air Pollution Project/Processed Data/res_no2_utr.csv")

# Aggregated stats
ams_tot <- read.csv("~/Air Pollution Project/Processed Data/ams_mob_total.csv")
utr_tot <- read.csv("~/Air Pollution Project/Processed Data/utr_total_v2.csv")

# unique journeys
tmp <- as.data.frame(table(utr_tot$OPID))
ggplot(tmp, aes(x = Freq)) +
  geom_bar() + 
  scale_x_continuous(breaks = 1:10) +
  ylim(0, 300) +
  xlab('Number of journeys declared') +
  ylab('Frequency')

# distinct ids
total_ams <- distinct(ams_tot)
utr_tot <- subset(utr_tot, select = -c(current_no2_x))
total_utr <- distinct(utr_tot)

total_ams$mean_dif <- (total_ams$res_no2 - total_ams$mob_no2)
total_utr$mean_dif <- (total_utr$Average_NO2 - total_utr$current_no2_y)

# check normality
ggdensity(total_utr$current_no2_y)
shapiro.test(total_ams$mean_dif)
shapiro.test(total_utr$current_no2_y)

# standard deviation of total differences
sd(total_ams$mean_dif)
sd(total_utr$mean_dif)

# mobility vs residential ams
t.test(ams_bike_stats$Average_NO2, ams_bike_stats$current_no2_y, paired = TRUE, var.equal = FALSE)
t.test(ams_car_stats$Average_NO2, ams_car_stats$current_no2_y,paired = TRUE, var.equal = FALSE)
t.test(ams_walk_stats$Average_NO2, ams_walk_stats$current_no2_y,paired = TRUE, var.equal = FALSE)

# total ams and total utr
t.test(ams_tot$res_no2, ams_tot$mob_no2, paired = TRUE, var.equal = FALSE)
t.test(utr_tot$Average_NO2, utr_tot$current_no2_y, paired = TRUE, var.equal = FALSE)

boxplot(ams_tot$res_no2, ams_tot$mob_no2, names= c('Residential', 'Mobility'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        xlab = 'NO2 Exposure Measure')

boxplot(ams_bike_stats$Average_NO2, ams_bike_stats$current_no2_y, 
        ams_car_stats$Average_NO2, ams_car_stats$current_no2_y,
        ams_walk_stats$Average_NO2, ams_walk_stats$current_no2_y,
        names= c('Bike Res', 'Bike Mob', 'Car Res', 'Car Mob', 'Foot Res', 'Foot Mob'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
         las = 2)

# mobility vs residential utrecht
t.test(utr_bike_stats$res_no2, utr_bike_stats$mob_no2)
t.test(utr_car_stats$res_no2, utr_car_stats$mob_no2)
t.test(utr_walk_stats$res_no2, utr_walk_stats$mob_no2)

boxplot(utr_tot$Average_NO2, utr_tot$current_no2_y, names= c('Residential', 'Mobility'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        xlab = 'NO2 Exposure Measure')

boxplot(utr_bike_stats$res_no2, utr_bike_stats$mob_no2, 
        utr_car_stats$res_no2, utr_car_stats$mob_no2,
        utr_walk_stats$res_no2, utr_walk_stats$mob_no2,
        names= c('Bike Res', 'Bike Mob', 'Car Res', 'Car Mob', 'Foot Res', 'Foot Mob'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        las = 2)

# total rivm
ams_rivm_tot <-read.csv("~/Air Pollution Project/Processed Data/ams_rivm_tot.csv")

# rivm data ams
ams_car_rivm <- read.csv("~/Air Pollution Project/Processed Data/ams_car_rivm_stats.csv")
ams_bike_rivm <- read.csv("~/Air Pollution Project/Processed Data/ams_bike_rivm_stats.csv")
ams_walk_rivm <- read.csv("~/Air Pollution Project/Processed Data/ams_walk_rivm_stats.csv")

# rivm data utrecht
utr_car_rivm <- read.csv("~/Air Pollution Project/Processed Data/utr_cars_rivm.csv")
utr_bike_rivm <- read.csv("~/Air Pollution Project/Processed Data/utr_bike_rivm.csv")
utr_walk_rivm <- read.csv("~/Air Pollution Project/Processed Data/utr_walk_rivm.csv")

# descriptives
boxplot(ams_car_rivm$rivm_nsl_2, ams_car_rivm$current_no2_y, names= c('Residential', 'Mobility'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        xlab = 'NO2 Exposure Measure')

boxplot(ams_tot$res_no2, ams_tot$mob_no2, ams_rivm_tot$rivm_no2, ams_rivm_tot$mob_no2, 
        names= c('Res', 'Mob', 'RIVM Res', 'RIVM Mob'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        xlab = 'NO2 Exposure Measure')

boxplot(ams_bike_rivm$rivm_nsl_2, ams_bike_rivm$current_no2_y, 
        ams_car_rivm$rivm_nsl_2, ams_car_rivm$current_no2_y,
        ams_walk_rivm$rivm_nsl_2, ams_walk_rivm$current_no2_y,
        names= c('Bike Res', 'Bike Mob', 'Car Res', 'Car Mob', 'Foot Res', 'Foot Mob'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        las = 2)

boxplot(ams_bike_rivm$rivm_nsl_2, ams_bike_rivm$current_no2_y, 
        ams_car_rivm$rivm_nsl_2, ams_car_rivm$current_no2_y,
        ams_walk_rivm$rivm_nsl_2, ams_walk_rivm$current_no2_y,
        names= c('Bike Res', 'Bike Mob', 'Car Res', 'Car Mob', 'Foot Res', 'Foot Mob'), 
        ylab = 'Average Hourly NO2 Exposure (µg/m3)',
        las = 2)

# bar plot of mean difference between residential and mobility
order_ams <- total_ams[order(total_ams$mean_dif, decreasing = TRUE),]
order_utr <- total_utr[order(total_utr$mean_dif, decreasing = TRUE),]
barplot(order_ams$mean_dif,
        ylab = 'Difference between hourly residential and mobility NO2 exposure (µg/m3)',
        xlab = 'Individual in Amsterdam')
barplot(order_utr$mean_dif,
        ylab = 'Difference between hourly residential and mobility NO2 exposure (µg/m3)',
        xlab = 'Individual in Utrecht')

# t test low res vs high res
t.test(ams_tot$res_no2, ams_rivm_tot$rivm_no2, paired = TRUE, var.equal = FALSE)
t.test(ams_tot$res_no2, ams_rivm_tot$rivm_no2, paired = TRUE, var.equal = FALSE)

# t test rivm vs high res ams
t.test(ams_car_stats$current_no2_y, ams_car_rivm$rivm_nsl_2)
t.test(ams_bike_stats$current_no2_y, ams_bike_rivm$rivm_nsl_2)
t.test(ams_walk_stats$current_no2_y, ams_walk_rivm$rivm_nsl_2)

# subsetting categories for socio-demographic analysis
myvars <- c( 'mean_dif', 'HHPers', 'Geslacht', 'Leeftijd', 
'Herkomst', 'BetWerk', 'Opleiding' )

# linear regression
df_ams <- left_join(total_ams, ams, by = 'OPID')
df_utr <- left_join(total_utr, utr, by = 'OPID')
ams_soc <- df_ams[myvars]
utr_soc <- df_utr[myvars]

# linear regression


lin <- lm(mean_dif~ ., data=ams_soc)
summary(lin)

lin_utr <- lm(mean_dif~., data=utr_soc)
summary(lin_utr)

summary(utr_tot)
