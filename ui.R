dashboardPage(
    dashboardHeader(title='Machine Learning App',titleWidth=240),
    dashboardSidebar(
        width=200,
        sidebarMenu(
          menuItem('Data Uploader',tabName='file'),
          menuItem('K- Nearest Neighbour',tabName='rf'),
          menuItem('Bagging',tabName='manhattan'),
          menuItem('Boosting',tabName='nDim'),
          menuItem('Boot Strap',tabName='k-nearest')
        )#end of sidebarMenu
    ),#end of Sidebar
    dashboardBody(
        tags$head(
        tags$link(rel="stylesheet",href="style.css")
        ),
        tabItems(
            tabItem(tabName = "file",
                    HTML("<h1> Data Uploader</h1>"),
                    fileInput('file1', 'Upload the data file',accept = c('text/csv','text/comma-separated-values','text/tab-separated-values','text/plain','.csv','.tsv')),
                    HTML("<h5>Note: We accept data in text/csv,text/comma-separated-values, text/tab-separated-values, text/plain,.csv or .tsv format</h5>"),
                    HTML("<h3>Data Preview</h3>"),
                    mainPanel(
                      dataTableOutput('contents')
                    )),
            tabItem(tabName='rf',
                    HTML("<h1> K-Nearest Neighbour </h1>"),
                    mainPanel(
                      fluidRow(
                        column(6,
                      uiOutput("select"),
                      uiOutput("resul")),
                      column(6,
                      HTML("<h1>Results</h1>"),      
                      dataTableOutput("table")))
                    )
                      ),#end of tabItem
            tabItem(tabName='manhattan'),#end of tabItem
            tabItem(tabName='nDim'),#end of tabItem
            tabItem(tabName='k-nearest')#end of tabItems
    )#end of Body
)#end of Dashboard
)

