observeEvent(input$replyIssue00, {
  queryReplyIssue01 <- reactive({dbGetQuery(db, paste0('SELECT uniqueIdentifier FROM ISSUES', input$issuesSelectProject))$uniqueIdentifier})
  showModal(modalDialog(title = 'Reply to issue',
                        selectInput(inputId = 'replyIssue01', label = 'Unique Identifier', choices = queryReplyIssue01()),
                        textAreaInput(inputId = 'replyIssue02', label = NULL, width = '600px', height = '200px', resize = 'none', placeholder = 'Please leave a comment.'),
                        selectInput(inputId = 'replyIssue03', label = 'Issue Status', choices = c('Open', 'Done', 'Closed'), selected = 'Done'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'replyIssue04', label = 'Submit'))
  ))
})

observeEvent(input$replyIssue04, {
  queryReplyIssue02 <- reactive({dbExecute(db, paste0('UPDATE ISSUES', input$issuesSelectProject, ' SET issueStatus = "', input$replyIssue03, ', reply = "Reply on ', Sys.Date(), ': ', input$replyIssue02, '" WHERE uniqueIdentifier = "', input$replyIssue01, '"'))})
  queryReplyIssue02()
  queryReplyIssue03 <- reactive({dbGetQuery(db, paste0('SELECT * FROM ISSUES', input$issuesSelectProject))})
  output$issues <- renderDT(datatable(data = queryReplyIssue03(), rownames = FALSE, colnames = colnamesIssues, filter = 'top'))
  removeModal()
})
