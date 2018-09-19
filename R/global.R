# library.list----
number <- 1:13
names(number) <- c("tidyverse","plotly","visNetwork","DT","DiagrammeR","gridExtra","magick",
                   "EBImage","RMySQL","RPostgreSQL","RODBC","leaflet","ggmap")
libraryName <- factor(names(number))
libraryList <- list(number=number, libraryName=libraryName)
libraryChoices <- as.list(libraryList$number)

# inputContents.list----
number <- 1:10
names(number) <- c("textInput","radioButtons","numericInput","sliderInput","selectInput",
                   "dateInput","dateRangeInput","fileInput","actionButton","checkboxGroupInput")
contents <- factor(names(number))
inputContents <- list(number=number, contents=contents)
inputContentsChoices <- as.list(inputContents$number)

# outputContents.list----
number <- 1:10
names(number) <- c("ggplot2","plotly","renderImage","leaflet","click_image",
                   "click_plot","DiagrammeR","visNetwork","verbatimTextOutput","dataTableOutput")
contents <- factor(names(number))
outputContents <- list(number=number, contents=contents)
outputContentsChoices <- as.list(outputContents$number)

# UIContentsCode.list----
UIContentsCode <- as.data.frame(matrix(c(
'ui.textinput',
'ui.radiobutton',
'ui.numericinput',
'ui.sliderinput',
'ui.selectinput',
'ui.dateinput',
'ui.daterangeinput',
'ui.fileinput',
'ui.actionbutton',
'ui.checkbox',
'ui.ggplot',
'ui.plotly',
'ui.image',
'ui.leaflet',
'ui.clickimage',
'ui.clickplot',
'ui.diagram',
'ui.visnet',
'ui.verbatimtext',
'ui.datatable',

'textInput("title", label="title",value="")',
'radioButtons("radiobutton", "Choose one:", c("A" = "1","B" = "2","C" = "3")),\ntextOutput("selected_radiobutton")',
'numericInput("numeric_input", "Input number:", 10, min = 1, max = 100),\nverbatimTextOutput("numericInputText")',
'sliderInput("slider_input", "Number of observations:",min = 0, max = 1000, value = 500),\nplotOutput("distPlot",height = 150)',
'selectInput("select_input","Select :",list("letters"=c("A","B","C"))),\ntextOutput("selectInputText")',
'dateInput("date_input", "Date:")',
'dateRangeInput("daterange_input", "Date range:",start = Sys.Date()-10,end = Sys.Date()+10)',
'fileInput("file_input",label = "Input File:"),\ntableOutput("fileContents")',
'actionButton("action_button","save data"),\nverbatimTextOutput("comment_actionButton")',
'checkboxGroupInput("checkbox_group_input", "Choose icons:",\nchoiceNames=list(icon("calendar"),icon("bed")),\nchoiceValues=list("calendar","bed")),\ntextOutput("txt")',
'plotOutput("ggplot",height=200)',
'plotlyOutput("plotly")',
'imageOutput("imageoutput")',
'leafletOutput("mapLeaflet")',
'imageOutput("clickImage",click = "image_click"),\nverbatimTextOutput("infoClickImageXY")',
'plotOutput("clickPlot",click ="plot_click"),\nverbatimTextOutput("infoClickPlotXY")',
'grVizOutput("diagram",width ="100%",height="300px")',
'visNetworkOutput("visnetwork")',
'verbatimTextOutput("verba_text")',
'dataTableOutput("DataTable")'
), ncol=2), stringsAsFactors = F)
colnames(UIContentsCode) <- c('contentsName', 'contentsText')

# ServerContentsCode2.list----
ServerContentsCode <- as.data.frame(matrix(c(
'server.textinput',
'server.radiobutton',
'server.numericinput',
'server.sliderinput',
'server.selectinput',
'server.dateinput',
'server.daterangeinput',
'server.fileinput',
'server.actionbutton',
'server.checkboxgroupinput',
'server.ggplot',
'server.plotly',
'server.image',
'server.leaflet',
'server.clickimage',
'server.clickplot',
'server.diagram',
'server.visnet',
'server.verbatimtext',
'server.datatable',

'',
'output$selected_radiobutton <- renderText({\npaste("You chose", input$radiobutton)\n})',
'output$numericInputText <- renderText({\ninput$numeric_input\n})',
'output$distPlot <- renderPlot({\nhist(rnorm(input$slider_input))\n})',
'output$selectInputText <- renderText({\npaste("You chose", input$select_input)\n})',
'',
'',
'output$fileContents <- renderTable({\ninFile <- input$file_input1\nif (is.null(inFile))\nreturn(NULL)\nread.csv(inFile$datapath, header = input$header)\n})',
'comment_save <- eventReactive(input$action_button,{\ncat("saveButton was pushed"\n)})\noutput$comment_actionButton <- renderText({\ncomment_save()\n})',
'output$txt <- renderText({\nicons <- paste(input$checkbox_group_input,collapse = ", ");paste("You chose", icons)\n})',
'output$ggplot <- renderPlot({\nggplot(iris,aes(Sepal.Width,Sepal.Length))+geom_point()\n})',
'output$plotly <- renderPlotly({\nplot_ly(z=volcano,type="heatmap")\n})',
'output$imageoutput <- renderImage({\n      filename <- normalizePath("../dog300.png")  \n      list(src=filename,width = 300)\n    }, deleteFile = FALSE)',
'output$mapLeaflet <- renderLeaflet({\nleaflet() %>% \naddProviderTiles(providers$Stamen.TonerLite,options = providerTileOptions(noWrap = TRUE))} %>% \naddMiniMap(tiles = providers$Esri.WorldStreetMap,toggleDisplay = TRUE))',
'output$clickImage <- renderImage({\n        list(src = "../ebimiso2.jpg",width = 400)\n    }, deleteFile = FALSE)\n    output$infoClickImageXY <- renderText({\n      paste0("x=",input$image_click$x,"y=",input$image_click$y)\n    })',
'output$clickPlot <- renderPlot({\nggplot(iris,aes(Sepal.Width,Sepal.Length))+geom_point()\n})\noutput$infoClickPlotXY <- renderText({\npaste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)\n})',
'output$diagram <- renderGrViz({\nnodes <- create_node_df(3)\nedges <- create_edge_df(from = 1:3,to = c(2,3,1))\ncreate_graph(nodes,edges) %>% render_graph()\n})',
'output$visnetwork <- renderVisNetwork({\nnodes <- data.frame(id = 1:3,label=1:3)\nedges <- data.frame(from = c(1,2,3), to = c(2,3,1))\nvisNetwork(nodes, edges)})',
'output$verba_text <- renderText({\ntext <- "sample text"\n})',
'output$DataTable <- renderDataTable({\nhead(iris[,c(1,2)],3) },options = list(pageLength = 5,searching = T))'
), ncol=2), stringsAsFactors = F)
colnames(ServerContentsCode) <- c('contentsName', 'contentsText')
