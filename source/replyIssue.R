observeEvent(input$replyIssue00, {
  queryReplyIssue01 <- reactive({dbGetQuery(db, paste0('SELECT uniqueIdentifier FROM tbl', input$replyIssueSelectProject))$uniqueIdentifier})
  showModal(modalDialog(title = 'Reply to issue',
                        selectInput(inputId = 'replyIssue01', label = 'Unique Identifier', choices = queryReplyIssue01()),
                        textAreaInput(inputId = 'replyIssue02', label = NULL, width = '600px', height = '200px', resize = 'none', placeholder = 'Please leave a comment.'),
                        selectInput(inputId = 'replyIssue03', label = 'Issue Status', choices = c('Open', 'Done', 'Closed'), selected = 'Done'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'replyIssue04', label = 'Submit'))
  ))
})

observeEvent(input$replyIssue04, {
  queryReplyIssue02 <- reactive({dbSendQuery(db, paste0("UPDATE tbl", input$replyIssueSelectProject, " SET issueStatus = '", input$replyIssue03, "', col05 = col05 || x'0a' || 'Reply on ", Sys.Date(), ": ' || '", input$replyIssue2, "', col06 = '", Sys.Date(), "' WHERE col01 = '", input$replyIssue1, "'"))})
  queryReplyIssue02()
  queryReplyIssue03 <- reactive({dbGetQuery(db, paste0('SELECT * FROM tbl', input$replyIssueSelectProject))})
  output$issues <- renderDT(datatable(data = queryReplyIssue03(), rownames = FALSE, colnames = c('Unique Identifier', 'Issue Status', 'Issue Description', 'Issue Opening Date', 'Reply', 'Issue Closing Date')))
  removeModal()
})
