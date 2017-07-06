function(input,output){

   output$contents <- renderDataTable({
    infile <- input$file1
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
        }
    read.csv(infile$datapath)
     })
   
   output$select<-renderUI({
     infile=input$file1
     data=read.csv(infile$datapath)
     mainPanel(
       fluidRow(
         column(6,
                selectInput('variables','Select the variables',choices=colnames(data),selectize = TRUE,multiple=TRUE)
                ),# end of 1 column
         column(6,
                selectInput('FacVac','Select the factor',choices=colnames(data),selected=NULL)
                )# end of 2 column
              ),# end of 1st row
       fluidRow(
         column(6,
                sliderInput('knn','Select No. of Nearest neighbour',min = 1,max=100,value =10),
                sliderInput('sample','Select  no. of sample required',min = 1,max=100,value =10),
                actionButton("results","Get Results")
         )# end of 1 column
        )
        )# end of panal
        })
   
    value<-eventReactive(input$results,{
      #output$table=renderDataTable(input$results,{
      
      df=data.frame()
      #Selecting data
      infile=input$file1
      
      #Reading File
      data=read.csv(infile$datapath)
      newdata=na.omit(data)
      set.seed(1)
      
      # creating test and train data
      for(i in 1:input$sample){
        indices = sample(floor(dim(newdata)[1]*.80),floor(dim(newdata)[1]*.20))
        train<-newdata[indices,]
        test<-newdata[-indices,]
        # Making variables Training and Test 
        train_wf=train[,input$variables]
        test_wf=test[,input$variables]
        
        # Making the classifications column as factor      
        train_fv1=as.factor(train[,input$FacVac])
        test_fv1=as.factor(test[,input$FacVac])
        print(head(train_fv1,5))
        
        # Creating a model with kNN
        #Model-1
        m1=knn(train_wf, test_wf, cl=train_fv1, k = input$knn, l = 0, prob = FALSE, use.all = TRUE)   
        #print(m1)
        p1=table(test_fv1, m1)
        #print(p1)
        results1=round(prop.table(p1, 1), 3) * 100
        #unq=length(unique(train_fv1))
        #for(j in 1:unq){
         # df[i,j]=results1[j,j]
        #}
        #print(df)
      }
      #m=input$sample+1
      #unq=length(unique(train_fv1))
      #for(j in 1:4){
      # df[m,j]=mean(df[,j])
      # df[m+1,j]=sd(df[,j])
      #  j=j+1
      #}
      write.csv(results1,"results.csv")
      
      output$table<-renderDataTable({
        read.csv("results.csv")
      })
      
      })
      output$resul=renderUI(value())
      
 
	}#end of shinyServer