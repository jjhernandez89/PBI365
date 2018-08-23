urlData = "https://github.com/CriticalPathTraining/PBI365/raw/master/Student/Data/SalesByCustomer.csv" 
customers <- read.csv(urlData)

names(customers) = c("Customer","State","Gender","Age","Sales")

customers <- customers[ order(customers$Sales, decreasing=TRUE), ]

# install plyr package if it is not currently installed 
if(!('plyr' %in% rownames(installed.packages()))){
  install.packages("plyr") 
}

library(plyr) 
customers$Gender <- mapvalues(customers$Gender, from = c("F", "M"), to = c("Female", "Male"))

ageGroups = c(0,17,29,39,49,64,100)
ageGroupLabels = c("Under 18", "18 to 29", "30 to 39", "40 to 49", "50 to 64", "65 and up")
customers$AgeGroup <- cut(customers$Age, breaks = ageGroups, labels = ageGroupLabels)

customers.florida = subset(customers, State == "FL", c("Customer", "Age") )

hist(customers.florida$Age, 
     main = "Florida Customer Count by Age", 
     col="lightblue", border="black", 
     ylab="Customer Count", 
     xlab="Customer Age", 
     xlim = c(20, 100), 
     breaks=50 )

customerSales.florida <- subset(customers, State == "FL", c( "AgeGroup", "Sales"))

customerSales.florida <- aggregate(customerSales.florida$Sales , 
                                   by=list(AgeGroup=customerSales.florida$AgeGroup), 
                                   sum)

barplot(customerSales.florida$x, 
        names.arg = customerSales.florida$AgeGroup, 
        ylab = "Sales Revenue", 
        main = "Florida Sales by Customer age", 
        col = c("red", "yellow","orange", "green", "blue") )

