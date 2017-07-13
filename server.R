function(input,output){

#-------Displaying the data file---------------
   output$data_input <- renderDataTable({
    infile <- input$file
    if (is.null(infile)) {
      # User has not uploaded a file yet
      return(NULL)
        }
    read.csv(infile$datapath)
     })
#--------END OF DATA INPUT---------------------  
#--------UI for K-Nearest Neighbour------------
   output$select<-renderUI({
     infile=input$file
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
#-----------END OF KNN UI----------------------
#-----------Data Status------------------------
   status<- eventReactive(input$file,{
     infile=input$file
     
     #Reading File
     data=read.csv(infile$datapath)
     
     #Checking data completion status
     if(any(is.na(data))=="TRUE"){
        return(HTML("<h2>Data Status:</h2><h3>Missing Data</h3><h4>Relax We Will Fix It</h4>"))
     }
     else
       return(HTML("<h2>Data Status:</h2><h3> No Missing Data"))
   })
#-----------K-Nearest Calcuations-------------
   
   value<-eventReactive(input$results,{

      df=data.frame()
      #Selecting data
      infile=input$file
      
      #Reading File
      data=read.csv(infile$datapath)
      
      #Filling Data
      m=mice(data=data,m=1)
      #Picking data from filled data
      newdata=complete(m,1)
      #for(i in 1:input$sample){
       
      #creating test and train data
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
        knn_model=knn(train_wf, test_wf, cl=train_fv1, k = input$knn, l = 0, prob = FALSE, use.all = TRUE)   
        result=table(test_fv1, knn_model)
        #print(p1)
        f_results=round(prop.table(result, 1), 3) * 100
        # code1 in rough.R
         write.csv(f_results,"results.csv")
      
      output$table<-renderDataTable({
        read.csv("results.csv")
      })
      
      })
   output$results=renderUI(value())
   output$data_status=renderUI(status())
 
	}#end of shinyServer