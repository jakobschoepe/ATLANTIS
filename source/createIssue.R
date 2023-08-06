observeEvent(input$createIssue00, {
  queryCreateIssue01 <- reactive({dbGetQuery(db, paste0('SELECT uniqueIdentifier FROM TASKS', input$createIssueSelectProject))$uniqueIdentifier})
  showModal(modalDialog(title = 'Create new issue',
                        selectInput(inputId = 'createIssue01', label = 'Unique Identifier', choices = queryCreateIssue01()),
                        textAreaInput(inputId = 'createIssue02', label = NULL, width = '600px', height = '200px', resize = 'none', placeholder = 'Please describe the issue.'),
                        selectInput(inputId = 'createIssue03', label = 'Issue Status', choices = c('Open', 'Done', 'Closed'), selected = 'Open'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'createIssue04', label = 'Submit'))
  ))
})

observeEvent(input$createIssue04, {
  queryCreateIssue02 <- reactive({dbGetQuery(db, paste0('SELECT * FROM ISSUES', input$createIssueSelectProject))})
  tmp01 <- ifelse(nrow(queryCreateIssue02()) < 1, 1, nrow(queryCreateIssue02()) + 1)
  tmp02 <- Sys.Date()
  queryCreateIssue03 <- reactive({dbExecute(db, paste0('INSERT INTO ISSUES', input$createIssueSelectProject, ' (uniqueIdentifier, issueStatus, issueDescription, issueOpeningDate) VALUES ("', input$createIssue01, '" (#"', tmp01, '"), "', input$createIssue03, '", "', input$createIssue02, '", "', tmp02, '")'))})
  queryCreateIssue03()
  output$issues <- renderDT(datatable(data = queryCreateIssue02(), rownames = FALSE, colnames = colnamesIssues, filter = 'top'))
  removeModal()
})
