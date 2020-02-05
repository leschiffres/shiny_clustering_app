library(caret)
library(cluster)    # clustering algorithms
library(factoextra)

dataset <- read.csv('Movie-Ratings.csv')


classes  <- sapply(X = dataset, FUN = class)
numeric_var <- which(classes == 'numeric' | classes == 'integer')

clust_dataset <- dataset[, numeric_var]
# str(clust_dataset)
clust_dataset <- data.frame(sapply(clust_dataset,function(x) as.numeric(as.character(x))))


# pca converts m-column data frame into two row so that it can be displayed
# scaling for pca
clust_dataset = scale(clust_dataset)

# applying pca
pca = preProcess(x = clust_dataset, method = 'pca', pcaComp = 2)
components = predict(pca, clust_dataset)

# a way to explain pca components can be the correlation of the pca components with the initial variables
cor(clust_dataset, components)

# k-means algorithm


# elbow rule

my_wcss <- function(x, k){
  set.seed(6)
  wcss <- vector()
  for(i in 1:10){
    wcss[i] <- sum(kmeans(x,i)$withins)
  }
  plot(1:10, wcss, type = 'b', 
       main = paste("Number of clusters", ylab = "WCSS"))
}


my_wcss(components, 10)


# kmeans algorithm
k <- 3 # select proper k based on the elbow rule
kmeans_results <- kmeans(components, k)

# visualize kmeans
visualize_kmeans <- function(x, kmeans_list){
  par(mar = c(5.1, 4.1, 0, 1))
  plot(x,
       col = kmeans_list$cluster,
       pch = 20, cex = 3)
  points(kmeans_list$centers, pch = 4, cex = 4, lwd = 4) 
}

visualize_kmeans(components, kmeans_results)

fviz_cluster(object = kmeans_results, data = components, geom = 'point')

