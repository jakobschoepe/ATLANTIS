observeEvent(input$createIssue00, {
  query <- reactive({dbGetQuery(db, paste0('SELECT uniqueIdentifier FROM tbl', input$createIssueSelectProject))$uniqueIdentifier})
  showModal(modalDialog(title = 'Create new issue',
                        selectInput(inputId = 'createIssue01', label = 'Unique Identifier', choices = query()),
                        textAreaInput(inputId = 'createIssue02', label = NULL, width = '600px', height = '200px', resize = 'none', placeholder = 'Please describe the issue.'),
                        selectInput(inputId = 'createIssue03', label = 'Issue Status', choices = c('Open', 'Done', 'Closed'), selected = 'Open'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'createIssue04', label = 'Submit'))
  ))
})

observeEvent(input$createIssue04, {
  queryCreateIssue01 <- reactive({dbGetQuery(db, paste0('SELECT * FROM tbl', input$createIssueSelectProject))})
  tmp01 <- ifelse(nrow(queryCreateIssue01()) < 1, 1, nrow(query01()) + 1)
  tmp02 <- Sys.Date()
  queryCreateIssue02 <- reactive({dbSendQuery(db, paste0('INSERT INTO tbl', input$createIssueSelectProject, ' (uniqueIdentifier, issueStatus, issueDescription, issueOpeningDate) VALUES ('", input$createIssue01, " (#", tmp01, ")', '", input$createIssue03, "', '", input$createIssue02, "', '", tmp02, "')"))})
  queryCreateIssue02()
  queryCreateIssue03 <- reactive({dbGetQuery(db, paste0('SELECT * FROM tbl', input$createIssueSelectProject))})
  output$issues <- renderDT(datatable(data = queryCreateIssue03(), rownames = FALSE, colnames = c('Unique Identifier', 'Issue Status', 'Issue Description', 'Issue Opening Date', 'Reply', 'Issue Closing Date')))
  removeModal()
})
