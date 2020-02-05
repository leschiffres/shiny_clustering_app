library(shinydashboard)
library(shinyWidgets)
library(shiny)
library(caret)
library(cluster)    # clustering algorithms
library(factoextra)
dashboardPage( skin = 'purple',
  dashboardHeader(title = "Clustering App",
                  tags$li(class = "dropdown", actionButton("debug", '', icon = icon('bug')))),

  dashboardSidebar(
    sidebarMenu(
                menuItem("Simple k-Means", tabName = "simple_kmeans", icon = icon("anchor")),
                menuItem("PCA k-Means", tabName = "pca_kmeans", icon = icon("address-book")),
                menuItem("Input CSV File", icon = icon('file'), tabname = 'file_loader',
                         fileInput('datafile',  'Select CSV File', accept = c('.csv')))
    )
  ),

  dashboardBody(
    
    tabItems(
      tabItem(tabName = "simple_kmeans",
              fluidRow(
                box(title = 'Simple k-Means Algorithm', width = 12, status = "warning", solidHeader = TRUE, collapsible = F,
                    column(width = 3,selectInput(inputId = 'variable1', 'First Variable', c('')),
                           actionButton('simple_kmeans_wcss_plot_button','WCSS Plot')),
                    column(width = 3,selectInput(inputId = 'variable2', 'Second Variable', c(''))),
                    column(width = 2,
                           br()
                    ),
                    column(width = 4,
                           selectInput(inputId = 'k_simple_kmeans', 'Choose k', c(1:10)),
                           actionButton('simple_kmeans_button', 'Run k-Means')
                    ),
                    column(width = 12,       
                           hr()
                    ),
                    
                    tabBox(id = "setScenarios", selected = "Multilateral", width = 12,
                           tabPanel("WCSS Plot", plotOutput('simple_kmeans_wss_plot')),
                           tabPanel("Results", plotOutput('simple_kmeans_cluster_plot'))
                    )
                ))
      ),
      tabItem(tabName = "pca_kmeans",
              fluidRow(
                box(title = 'k-Means Algorithm using PCA', width = 12, status = "warning", solidHeader = TRUE, collapsible = F,
                    column(width = 3,multiInput(inputId = 'variables_pca', 'First Variable', c('')),
                           actionButton('pca_kmeans_wcss_plot_button','WCSS Plot')),
                    column(width = 2,
                           br()
                    ),
                    column(width = 4,
                           selectInput(inputId = 'k_pca_kmeans', 'Choose k', c(1:10)),
                           actionButton('pca_kmeans_button', 'Run k-Means')
                    ),
                    column(width = 12,       
                           hr()
                    ),
                    
                    tabBox(id = "setScenarios", selected = "Multilateral", width = 12,
                           tabPanel("WCSS Plot", plotOutput('pca_kmeans_wss_plot')),
                           tabPanel("Results", plotOutput('pca_kmeans_cluster_plot'))
                    )
                ))
      )
      
    )
  )
)