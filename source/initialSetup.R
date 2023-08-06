queryInitialSetup01 <- reactive({dbGetQuery(db, paste0('SELECT * FROM TASKS', input$tasksSelectProject))})
output$tasks <- renderDT(datatable(data = queryInitialSetup01(), rownames = FALSE, colnames = colnamesTasks, filter = 'top'))
queryInitialSetup02 <- reactive({dbGetQuery(db, paste0('SELECT * FROM ISSUES', input$issuesSelectProject))})
output$issues <- renderDT(datatable(data = queryInitialSetup02(), rownames = FALSE, colnames = colnamesIssues, filter = 'top'))
