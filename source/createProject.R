observeEvent(input$createProject00, {
  showModal(modalDialog(title = 'Create new project',
                        textInput(inputId = 'createProject01', label = NULL, placeholder = 'Please enter a unique project identifier'),
                        textInput(inputId = 'createProject02', label = NULL, placeholder = 'Please enter a project name'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'createProject03', label = 'Submit'))))
})

observeEvent(input$createProject03, {
  dbExecute(db, paste0('INSERT INTO PROJECTS (uniqueIdentifier, projectName) VALUES ("', input$createProject01, '", "', input$createProject02, '")')) 
  queryCreateProject01 <- reactive({dbSendQuery(db, paste0('CREATE TABLE TASKS', input$createProject01, ' (uniqueIdentifier varchar(255), title varchar(255), programName varchar(255), outputType varchar(255), outputName varchar(255), reference varchar(255), programmingStatus varchar(255), assignedStatisticalProgrammer varchar(255), programmingAssignmentDate varchar(255), programmingSpecifications varchar(255), programmingDate varchar(255), qualityControllingStatus varchar(255), assignedQualityController varchar(255), qualityControllingAssignmentDate varchar(255), qualityControllingSpecifications varchar(255), qualityControllingDate varchar(255), deliveryStatus varchar(255), deliveryDate varchar(255))'))})
  queryCreateProject01()
  queryCreateProject02 <- reactive({dbSendQuery(db, paste0('CREATE TABLE ISSUES', input$createProject01, ' (uniqueIdentifier varchar(255), issueStatus varchar(255), issueDescription varchar(255), issueOpeningDate varchar(255), reply varchar(255), issueClosingDate varchar(255))'))})
  queryCreateProject02()
  output$projects <- renderDT(datatable(data = dbGetQuery(db, 'SELECT * FROM PROJECTS'), rownames = FALSE, colnames = colnamesProjects))
  removeModal()
})
