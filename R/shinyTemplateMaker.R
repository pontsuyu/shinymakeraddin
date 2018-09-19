#' shinyTemplateMaker
#'
#' @import shiny
#' @name shinyTemplateMaker
#' 

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

shiny_theme_selector <- function () {
  fixedPanel(top = "10px", left = "380px", draggable = FALSE,
             style = "width: 800px;z-index: 100000;",
             div(class = "panel panel-danger", 
                 div(tags$table(
                   tags$th(div(style = "text-align:center;width:220px;",
                               "Shiny Theme Tester:")),
                   tags$th(div(style = "margin:10px;width:150px;", 
                               selectInput("shinytheme-selector", NULL,
                                           c("default", shinythemes:::allThemes()),
                                           selectize = FALSE))),
               tags$th(div(style = "margin:5px 30px;width:200px;",
                           actionButton("save_shiny","make shinycode"),
                           verbatimTextOutput("comment1"))),
               tags$th(div(style = "margin:5px auto;width:150px;",
                           actionButton("confirm_code", "display code")))))),
             tags$script("$('#shinytheme-selector')\n
                         .on('change', function(el) {\n
                         var allThemes = $(this).find('option').map(function() {\n
                         if ($(this).val() === 'default')\n
                         return 'bootstrap';\n
                         else\n
                         return $(this).val();\n
                         });\n\n
                         // Find the current theme\n
                         var curTheme = el.target.value;\n
                         if (curTheme === 'default') {\n
                         curTheme = 'bootstrap';\n
                         curThemePath = 'shared/bootstrap/css/bootstrap.min.css';\n
                         } else {\n
                         curThemePath = 'shinythemes/css/' + curTheme + '.min.css';\n
                         }\n\n
                         // Find the <link> element with that has the bootstrap.css\n
                         var $link = $('link').filter(function() {\n
                         var theme = $(this).attr('href');\n
                         theme = theme.replace(/^.*\\//, '').replace(/(\\.min)?\\.css$/, '');\n
                         return $.inArray(theme, allThemes) !== -1;\n
                         });\n\n
                         // Set it to the correct path\n
                         $link.attr('href', curThemePath);\n
                         });"))
}

# UI----
ui <- fluidPage(shiny_theme_selector(),
                titlePanel("ShinyMaker"),
                br(),br(),
                fluidRow(
                  column(1),
                  column(2,
                         h3("Frame"),
                         textInput("title", label=h5("Title :"), value="sample"),
                         radioButtons("sidebar", label = h5("Sidebar :"),
                                      choices = list("yes"  = 1,
                                                     "no"   = 2), selected = 2),
                         radioButtons("tab", label = h5("Tab :"),
                                      choices = list("yes"  = 1,
                                                     "no"   = 2), selected = 2)
                  ),
                  column(2,
                         radioButtons("theme", label = h3("Theme"),
                                      choices = list("default"  = 1,
                                                     "cerulean" = 2,
                                                     "cosmo"    = 3,
                                                     "cyborg"   = 4,
                                                     "darkly"   = 5,
                                                     "flatly"   = 6,
                                                     "journal"  = 7,
                                                     "lumen"    = 8,
                                                     "paper"    = 9,
                                                     "readable" = 10,
                                                     "sandstone"= 11,
                                                     "simplex"  = 12,
                                                     "slate"    = 13,
                                                     "spacelab" = 14,
                                                     "superhero"= 15,
                                                     "united"   = 16,
                                                     "yeti"     = 17), selected = 1)
                  ),
                  column(2,
                         checkboxGroupInput("library_list", label = h3("Libraries"), 
                                            choices = libraryChoices,
                                            selected = 1:4)
                  ),
                  column(2,
                         checkboxGroupInput("inputContentsList", label = h3("Input contents"), 
                                            choices = inputContentsChoices,
                                            selected = 1)
                  ),
                  column(2,
                         checkboxGroupInput("ouputContentsList", label = h3("Output contents"), 
                                            choices = outputContentsChoices,
                                            selected = 1)
                  )),
                
                column(12,
                       tabsetPanel(
                         tabPanel("ui.R", verbatimTextOutput("uicode")),  
                         tabPanel("server.R", verbatimTextOutput("servercode")) 
                       )
                )
)

# SERVER----
server <- function(input, output, session){
  ServerContentsCode <- read.csv("ServerContentsCode.csv", stringsAsFactors = F)
  UIContentsCode <- read.csv("UIContentsCode.csv", stringsAsFactors = F)
  comment1 <- eventReactive(input$save_shiny,{
    # library.part of shiny.code----
    libraryCommnetCode <- '\n# library----'
    makeLibraryCode <- function(libraryList){
      paste0('library(', libraryList, ')')
    }
    libraryCode <- sapply(libraryList$libraryName, makeLibraryCode)
    neededLibraryNumber <- as.numeric(input$library_list)
    libraryCode <- libraryCode[neededLibraryNumber]
    libraryCode <- c(libraryCommnetCode, libraryCode)
    
    # ui.part of shiny.code----
    shinyUI.head <- '\n# ui----\nshinyUI('
    shinyUI.tail <- ')'
    
    if(input$theme==1){
      ui.fluidpage.h <- 'fluidPage('
    } else{
      switch(input$theme,
             # "1"= stheme <- "default",  # default doesn't work
             "2"  = stheme <- "cerulean",
             "3"  = stheme <- "cosmo",
             "4"  = stheme <- "cyborg",
             "5"  = stheme <- "darkly",
             "6"  = stheme <- "flatly",
             "7"  = stheme <- "journal",
             "8"  = stheme <- "lumen",
             "9"  = stheme <- "paper",
             "10" = stheme <- "readable",
             "11" = stheme <- "sandstone",
             "12" = stheme <- "simplex",
             "13" = stheme <- "slate",
             "14" = stheme <- "spacelab",
             "15" = stheme <- "superhero",
             "16" = stheme <- "united",
             "17" = stheme <- "yeti"
      )
      ui.fluidpage.h <- paste0('fluidPage(theme = shinytheme("',stheme,'"),')
    }
    ui.fluidpage.t <- ')'
    
    ui.title <- paste0('titlePanel("',input$title,'"),')
    
    ui.pagebody.h1 <- 'fluidRow('
    ui.pagebody.h2 <- 'fluidRow(\ncolumn(3,\nwellPanel("SideBar")\n),\ncolumn(9,\nfluidRow('
    ui.pagebody.t1 <- ')'
    ui.pagebody.t2 <- ')\n)\n)'
    comma <- ','
    
    # sidebar
    if(input$sidebar == 2){             # no
      ui.pagebody.h <- ui.pagebody.h1
      ui.pagebody.t <- ui.pagebody.t1
    } else if(input$sidebar == 1){      # yes
      ui.pagebody.h <- ui.pagebody.h2
      ui.pagebody.t <- ui.pagebody.t2
    }
    
    # iutput/outputContentsNumber is selected content-numbers
    inputContentsNumber <- as.numeric(input$inputContentsList)
    outputContentsNumber <- as.numeric(input$ouputContentsList)
    # inputとoutputの選択番号を連番に
    contentNumber <- c(inputContentsNumber, outputContentsNumber + max(inputContents$number))
    
    tuckCodeIntoColumn4 <- function(code) paste("column(4,\n", code, "\n)")
    tuckedCode <- sapply(UIContentsCode$contentsText[contentNumber], tuckCodeIntoColumn4)
    tuckedCode <- tuckedCode[tuckedCode != ""]
    connectedUIContentsCode <- paste(tuckedCode, collapse=",\n")
    
    # add tab
    if(input$tab==1){   
      tab.code <- 'column(4,\ntabsetPanel(\ntabPanel("tabA",\nh3("testA")\n),\ntabPanel("tabB",\nh3("testB")\n)\n)\n),'
      connectedUIContentsCode <- c(tab.code, connectedUIContentsCode)
    }
    
    # CodeFrame(header,sidebar part)
    code.ui <- c(shinyUI.head,
                 ui.fluidpage.h,         
                 ui.title,         
                 ui.pagebody.h,
                 connectedUIContentsCode,
                 ui.pagebody.t,
                 ui.fluidpage.t,
                 shinyUI.tail)
    
    # server.part of shiny.code----
    # make server.header/tail code----
    server.h <- '\n# server----\nshinyServer(\nfunction(input, output) { '
    server.h2 <- '\n# server----\nshinyServer(\nfunction(input, output, session) { '
    server.t <- '}\n)'
    
    # actionボタン使うときはsession入れる
    server.h <- ifelse(9 %in% inputContentsNumber, server.h2, server.h)
    
    # 空白ベクトルを削除
    ServerContentsCode_withBlanck <- ServerContentsCode$contentsText[contentNumber]
    ServerContentsCode_withoutBlanck <- ServerContentsCode_withBlanck[ServerContentsCode_withBlanck!=""]
    connectedServerContentsCode <- paste(ServerContentsCode_withoutBlanck, collapse = "\n")
    code.server <- c(server.h, connectedServerContentsCode, server.t)
    
    # make whole code----
    # record shiny execute file---
    if(!(input$title %in% list.files(getwd()))) dir.create(paste0(getwd(), "/", input$title))
    uiCode <- c(libraryCode, code.ui)
    write(uiCode, file = paste0(input$title, "/ui.R"))
    code.server <- c(libraryCode, code.server)
    write(code.server, file = paste0(input$title, "/server.R"))
    text <- 'Files were created.'
  })
  output$comment1 <- renderText({
    comment1()
  })
  output$txt_lib <- renderText({
    str(input$library_list)
  })
  output$uicode <- renderText({
    input$confirm_code
    if("ui.R" %in% list.files(paste0(getwd(), "/", input$title))){
      uicode <- readLines(paste0(input$title, "/ui.R"))
      uicode <- paste(uicode, collapse = "\n")
    } else {
      uicode <- "File does not exist"
    }
  })
  output$servercode <- renderText({
    input$confirm_code
    if("server.R" %in% list.files(paste0(getwd(), "/", input$title))){
      servercode <- readLines(paste0(input$title, "/server.R"))
      servercode <- paste(servercode, collapse = "\n")
    } else {
      servercode <- "File does not exist"
    }
  })
}

# shinyApp----
shinyTemplateMaker <- function(){
  shinyApp(ui, server)
}

