observeEvent(input$createProject00, {
  showModal(modalDialog(title = 'Create new project',
                        textInput(inputId = 'createProject01', label = NULL, placeholder = 'Please enter a unique project identifier'),
                        footer = tagList(modalButton('Cancel'), actionButton(inputId = 'createProject02', label = 'Submit'))))
})

observeEvent(input$createProject02, {
  queryCreateProject01 <- reactive({dbGetQuery(db, paste0('CREATE TABLE tbl', input$createProject01, ' (uniqueIdentifier varchar(255), 
                                                                                                        title varchar(255), 
                                                                                                        programName varchar(255), 
                                                                                                        outputType varchar(255), 
                                                                                                        outputName varchar(255), 
                                                                                                        reference varchar(255), 
                                                                                                        programmingStatus varchar(255), 
                                                                                                        assignedStatisticalProgrammer varchar(255), 
                                                                                                        programmingAssignmentDate varchar(255), 
                                                                                                        programmingSpecifications varchar(255),
                                                                                                        programmingDate varchar(255),
                                                                                                        qualityControllingStatus varchar(255),
                                                                                                        assignedQualityController varchar(255),
                                                                                                        qualityControllingAssignmentDate varchar(255),
                                                                                                        qualityControllingSpecifications varchar(255),
                                                                                                        qualityControllingDate varchar(255),
                                                                                                        deliveryStatus varchar(255),
                                                                                                        deliveryDate varchar(255))'
                                    ))
                                   })
  queryCreateProject01()
  
})
