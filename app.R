library(DT)
library(RSQLite)
library(shiny)
library(shinyjs)
library(shinythemes)

if(!file.exists('ATLANTIS.db')) {
  db <- dbConnect(SQLite(), dbname = 'ATLANTIS.db')
  dbSendQuery(db, 'CREATE TABLE PROJECTS (uniqueIdentifier varchar(255), projectName varchar(255))')
}

if(file.exists('ATLANTIS.db')) {
  db <- dbConnect(SQLite(), dbname = 'ATLANTIS.db')
}

version <- 'Version: 0.1b (6 August 2023)'
creator <- 'Jakob Schöpe'
year <- format(Sys.Date(), '%Y')
colnamesProjects <- c('Unique Identifier', 'Project Name')
colnamesTasks <- c('Unique Identifier', 'Title', 'Program Name', 'Output Type', 'Output Name', 'Reference', 'Programming Status', 'Statistical Programmer', 'Programming Specifications', 'Programming Completion Date', 'Quality Controlling Status', 'Quality Controller', 'Quality Controlling Specifications', 'Quality Controlling Completion Date', 'Delivery Status', 'Delivery Date')
colnamesIssues <- c('Unique Identifier', 'Issue Status', 'Issue Description', 'Issue Opening Date', 'Reply', 'Issue Closing Date')

ui <- fluidPage(tags$head(HTML("<title>ATLANTIS</title> <link rel='icon' type='image/gif/png' href='favicon.png'>")),
                shinyjs::useShinyjs(),
                navbarPage(strong('ATLANTIS'),
                           navbarMenu('Home',
                                      tabPanel('Projects',
                                               div(div(style='display: inline-block; width: 135px;', actionButton(inputId = 'createProject00', label = 'Create project', icon = icon('plus', lib = 'font-awesome'))),
                                                   div(style='display: inline-block; width: 100px;', actionButton(inputId = 'editProject00', label = 'Edit project', icon = icon('pen-to-square', lib = 'font-awesome')))
                                                  ),
                                               br(),
                                               br(),
                                               DTOutput(outputId = 'projects'),
                                               br(),
                                               br(),
                                               p(HTML('&#169;'), year, creator, align = 'center')
                                              ),
                                      tabPanel('Tasks',
                                               textOutput(outputId = 'tasksNotification'),
                                               selectInput(inputId = 'tasksSelectProject', label = 'Project', choices = dbGetQuery(db, 'SELECT uniqueIdentifier FROM PROJECTS')),
                                               br(),
                                               div(div(style='display: inline-block; width: 100px;', actionButton(inputId = 'createTask00', label = 'Create task', icon = icon('plus', lib = 'font-awesome'))),
                                                   div(style='display: inline-block; width: 100px;', actionButton(inputId = 'editTask00', label = 'Edit task', icon = icon('pen-to-square', lib = 'font-awesome')))
                                                  ),
                                               br(),
                                               br(),
                                               DTOutput(outputId = 'tasks'),
                                               br(),
                                               br(),
                                               p(HTML('&#169;'), year, creator, align = 'center')
                                              ),
                                      tabPanel('Issues',
                                               textOutput(outputId = 'issuesNotification'),
                                               selectInput(inputId = 'issuesSelectProject', label = "Project", choices = dbGetQuery(db, 'SELECT uniqueIdentifier FROM PROJECTS')),
                                               br(),
                                               div(div(style='display: inline-block; width: 120px;', actionButton(inputId = 'createIssue00', label = 'Create issue', icon = icon('plus', lib = 'font-awesome'))),
                                                   div(style='display: inline-block; width: 120px;', actionButton(inputId = 'editIssue00', label = 'Edit issue', icon = icon('pen-to-square', lib = 'font-awesome'))),
                                                   div(style='display: inline-block; width: 120px;', actionButton(inputId = 'replyIssue00', label = 'Reply to issue', icon = icon('reply', lib = 'font-awesome')))
                                                  ),
                                               br(),
                                               br(),
                                               DTOutput(outputId = 'issues'),
                                               br(),
                                               br(),
                                               p(HTML('&#169;'), year, creator, align = 'center')
                                              )
                                     ),
                           navbarMenu('Help',
                                      tabPanel('About', 
                                               h4(strong('ATLANTIS'), align = 'center'),
                                               h5(version, align = 'center'),
                                               p("ATLANTIS is an open-source statistical programming tracking system.", align = "center"),
                                               br(),
                                               h4(strong("Software License Agreement"), align = "center"),
                                               br(),
                                               br(),
                                               p(HTML('&#169;'), year, creator, align = 'center')
                                              )
                                     )
))

server <- function(input, output, session) {
  source('./source/initialSetup.R', local = TRUE)$value
  source('./source/createProject.R', local = TRUE)$value
  source('./source/createIssue.R', local = TRUE)$value
  source('./source/replyIssue.R', local = TRUE)$value
}

shinyApp(ui, server)
