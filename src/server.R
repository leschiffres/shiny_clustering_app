server <- function(input, output, session) { 
  
  # ---------------------------------------------------------------------------------- #
  # --------------------------------- PCA & k-means ---------------------------------- #
  # ---------------------------------------------------------------------------------- #
  
  observeEvent(input$pca_kmeans_button,{
    
    temp_data <- filedata()[, c(input$variables_pca)] 
    
    pca = preProcess(x = temp_data, method = 'pca', pcaComp = 2)
    components = predict(pca, temp_data)
    
    # browser()
    
    k <- input$k_pca_kmeans
    kmeans_results <- kmeans(components, k)
    output$pca_kmeans_cluster_plot <- renderPlot(
      fviz_cluster(object = kmeans_results, data = components, geom = 'point')
    )
  })
  
  observeEvent(input$pca_kmeans_wcss_plot_button,{
    
    temp_data <- filedata()[, c(input$variables_pca)]
    
    pca = preProcess(x = temp_data, method = 'pca', pcaComp = 2)
    components = predict(pca, temp_data)
    
    output$pca_kmeans_wss_plot <- renderPlot(
      isolate(my_wcss(components, 10))
    )
  })
  
  # ---------------------------------------------------------------------------------- #
  # --------------------------------- Simple k-means --------------------------------- #
  # ---------------------------------------------------------------------------------- #
  
  # execute simple kmeans algorithm
  observeEvent(input$simple_kmeans_button,{
    
    temp_data <- filedata()[, c(input$variable1, input$variable2)]
    # temp_data <- filedata() # used only when kmeans is based on every column instead of the above command
    k <- input$k_simple_kmeans
    kmeans_results <- kmeans(temp_data, k)
    
    output$simple_kmeans_cluster_plot <- renderPlot(
      fviz_cluster(object = kmeans_results, data = temp_data[, c(input$variable1, input$variable2)], geom = 'point')
    )
  })
  
  # wcss_plot for simple k means algorithm
  observeEvent(input$simple_kmeans_wcss_plot_button,{
    
    temp_data <- filedata()[, c(input$variable1, input$variable2)]
    # temp_data <- filedata() # used only when kmeans is based on every column instead of the above command
    
    output$simple_kmeans_wss_plot <- renderPlot(
      isolate(my_wcss(temp_data, 10))
      )
  })
  
  
  # ---------------------------------------------------------------------------------- #
  # --------------------------------- Other Functions -------------------------------- #
  # ---------------------------------------------------------------------------------- #
  
  my_wcss <- function(x, k){
    set.seed(6)
    wcss <- vector()
    for(i in 1:10){
      wcss[i] <- sum(kmeans(x,i)$withins)
    }
    plot(1:10, wcss, type = 'b', 
         main = paste("Number of clusters", ylab = "WCSS"))
  }
  
  observeEvent(input$debug,{
    browser()
  })  
  
  # ---------------------------------------------------------------------------------- #
  # ----------------------------------- Loading File --------------------------------- #
  # ---------------------------------------------------------------------------------- #
  
  # returns a data frame with the data after keeping only the numeric variables
  filedata <- reactive({
    infile <- input$datafile # this triggers the function
    if (is.null(infile))
      # User has not uploaded a file yet. Use NULL to prevent observeEvent from triggering
      return(NULL)
    dataset <- read.csv(infile$datapath)
    
    classes  <- sapply(X = dataset, FUN = class)
    numeric_var <- which(classes == 'numeric' | classes == 'integer')
    
    clust_dataset <- dataset[, numeric_var]
    clust_dataset <- data.frame(sapply(clust_dataset,function(x) as.numeric(as.character(x))))
    clust_dataset <- as.data.frame(scale(clust_dataset))
    return(clust_dataset)
  })
  
  # load the select inputs
  observeEvent(filedata(), {
    data = filedata()
    classes  <- lapply(X = data, FUN = class)
    updateSelectInput(session, "variable1", choices = colnames(data))
    updateSelectInput(session, "variable2", choices = colnames(data))
    updateSelectInput(session, "variables_pca", choices = colnames(data))
  })
}