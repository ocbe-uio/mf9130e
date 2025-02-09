# survival analysis 
# first install and load package 
# install.packages("survival")
library(survival)


# ex 1: melanoma ----
# effect on survival on the patient's gender and tumor thickness

melanoma <- read.csv('./lab/data/melanoma.csv')
head(melanoma)

colnames(melanoma)
melanoma[1,]

# a)  -----
# event of interest: death from disease

# variables: 
# status: 1 = death from disease, 2 = censored, 4 = death form other causes
# lifetime: years from operation
# tumor_thickness: 1/100mm
# age
# gender: f = 1, m = 2


# code status == 1 (death) or else 0
# you can also use 'factor' function
death <- ifelse(melanoma$status == 1, 1, 0)

# death <- factor(melanoma$status, 
#                 levels = c('1', '0'),
#                 labels = c('Death from melanoma', 'Death from others'))

# check if it is correct
table(death)
table(melanoma$status)
lifetime <- melanoma$lifetime


# b) ----
# make a Kaplan-Meier plot 
# fit a survival function with lifetime and death data

km_fit <- survfit(Surv(lifetime, death) ~ 1)
plot(km_fit)

# add title and text
title(main = 'Kaplan-Meier survival estimate', 
      xlab = 'Time', 
      ylab = 'Survival probability')


# time 1, 2, 5
tme <- c(1, 2, 5)
summary(km_fit, times = tme)



# c) ----
# compare survival according to gender
# gender == 1: female; gender == 2: male
gender <- melanoma$gender


km_fit_gender <- survfit(Surv(lifetime, death) ~ gender)
plot(km_fit_gender, col = c('blue', 'red'))
title(main = 'Kaplan-Meier survival estimate: stratify by gender', 
      xlab = 'Time', 
      ylab = 'Survial probability')

# add legend
legend( 'bottomleft', 
       legend = c('Female', 'Male'), 
       lty = c('solid', 'solid'), 
       col = c('blue','red'))


# test difference with logrank test 
survdiff(Surv(lifetime, death) ~ gender)


# d) ----
# tumor thickness
# take out the variable
melanoma$grouped_tumor_thickness

grouped_tumor_thickness <- melanoma$grouped_tumor_thickness

# how many in each category
table(grouped_tumor_thickness)
 

# fit km 
km_fit_tumor <- survfit(Surv(lifetime, death) ~ grouped_tumor_thickness)
plot(km_fit_tumor, col = c('blue', 'red', 'forestgreen'))

title(main = 'Kaplan-Meier survival estimate: stratify by tumor thickness', 
      xlab = 'Time', 
      ylab = 'Survial probability')

# add legend
legend( 'bottomleft', 
        legend = c('0-2 mm', '2-5 mm', '5+ mm'), 
        lty = c('solid', 'solid', 'solid'), 
        col = c('blue','red', 'forestgreen'))


# test difference with logrank test 
survdiff(Surv(lifetime, death) ~ grouped_tumor_thickness)



# ex3: length of hospital stay ----

liggetid <- read.csv('./lab/data/liggetid.csv')
head(liggetid)

# all status are 1 
status <- liggetid$status

# a) ----
# length of stay (los) vs gender
los <- liggetid$liggetid
los

# can choose to recode; or leave as it is;
# gender == 0: female; gender == 1: male
gender <- liggetid$kjoenn
gender

# fit km 
km_liggetid_gender <- survfit(Surv(los, status) ~ gender)

plot(km_liggetid_gender, col = c('blue', 'red'))

title(main = 'Kaplan-Meier survival estimate: stratify by gender', 
      xlab = 'Time', 
      ylab = 'Survial probability')

# add legend
legend( 'topright', 
        legend = c('Female', 'Male'), 
        lty = c('solid', 'solid'), 
        col = c('blue','red'))



# log rank test 
survdiff(Surv(los, status) ~ gender)


# b) ----
# length of stay vs stroke
# slag == 1: yes, slag == 2: no
stroke <- liggetid$slag

# fit km 
km_liggetid_stroke <- survfit(Surv(los, status) ~ stroke)

plot(km_liggetid_stroke, col = c('blue', 'red'))

title(main = 'Kaplan-Meier survival estimate: stratify by stroke', 
      xlab = 'Time', 
      ylab = 'Survial probability')

# add legend
legend( 'topright', 
        legend = c('Stroke: yes', 'Stroke: no'), 
        lty = c('solid', 'solid'), 
        col = c('blue','red'))


# log rank test
survdiff(Surv(los, status) ~ stroke)


