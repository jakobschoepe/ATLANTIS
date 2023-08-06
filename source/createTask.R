observeEvent(input$createTask00, {
  showModal(modalDialog(title = 'Create new task',
                        fileInput(inputId = 'createTask01', label = NULL, accept = '.csv'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'createTask02', label = 'Submit'))
  ))
})

observeEvent(input$createTask02, {
  queryCreateTask01 <- reactive({dbAppendTable(db, paste0('TASKS', input$createTaskSelectProject), read.csv(createTask01$datapath))})
  queryCreateTask01()
  queryCreateTask02 <- reactive({dbGetQuery(db, paste0('SELECT * FROM TASKS', input$createTaskSelectProject))})
  output$tasks <- renderDT(datatable(data = queryCreateTask02(), rownames = FALSE, colnames = colnamesIssues, filter = 'top'))
  removeModal()
})