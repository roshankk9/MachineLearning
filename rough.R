data=read.csv("vgsales.csv")
data<-data[c("Genre","NA_Sales","EU_Sales","JP_Sales","Other_Sales", "Global_Sales")]
facVAc="Genre"
facVAc=noquote(facVAc)
data<-data%>%
  filter(Genre=='Action'|Genre=='Sports')
facVAc<-factor(facVAc,levels=c('Action','Sports'))
length=dim(vgsales)[1]
set.seed(1)
vgsales=na.omit(vgsales)
indices<-sample(length,length/2)
train<-vgsales[indices,]
test<-vgsales[-indices,]
fit<-randomForest(input$FacVAc~.,data=train,mtry=2,ntree=input$NTree)
print(fit)
test$classification<-predict(fit,newdata=test,response='class')
text=length(which(test$Genre != test$classification))/dim(test)[1]


#identifier=which(colnames(data)==input$FacVAc)
#newdata=cbind(data[identifier],variables)
#filterdata<-newdata%>%
#filter(newdata[1]==input$filter1|newdata[1]==input$filter2)
#filterdata$Genre=factor(filterdata$Genre,levels=c(input$filter1,input$filter2))


d=(noquote(colnames(train)[1]))
fit<-randomForest(input$FacVAr~input$variables,data=train,mtry=2,ntree=input$NTree)
test$classification<-predict(fit,newdata=test,response='class')
text=length(which(test$Genre != test$classification))/dim(test)[1]

# code 1
#unq=length(unique(train_fv1))
#for(j in 1:unq){
# df[i,j]=results1[j,j]
#}
#print(df)
#}
#m=input$sample+1
#unq=length(unique(train_fv1))
#for(j in 1:4){
# df[m,j]=mean(df[,j])
# df[m+1,j]=sd(df[,j])
#  j=j+1
#}
# end od code 1