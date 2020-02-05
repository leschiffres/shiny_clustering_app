# Shiny Clustering App
This is a basic shiny app that uses the shiny dashboard and applies a clustering algorithm to a given dataset. I have containerized the app so that you the functionality of the app can be tested, without having to install anything apart from docker. If you don't have docker installed then just go to https://docs.docker.com/install/.

## Run the app
- Clone the repository in your local directory through terminal using the command 

```git clone git@github.com:leschiffres/shiny_clustering_app.git```
- Using terminal jump to the directory where the cloned git repo is located.
- Build the image `docker build -t my-shiny-app .`
- Start the container `docker run --rm -p 3838:3838 my-shiny-app`
- Open a browser and go to `http://localhost:3838`

## Steps to check app
I made this small project to play with *R-shiny* and run some R algorithms in the background. The algorithm used for clustering purposes is the *k-Means* algorithm.

If you did the previous steps, the app be running in the browser. First thing one should do is to load a dataset using the _input csv section_.

In the app there are two sections.
- In the first one names _Simple k-means_, the user can pick two variables (only the numeric ones are kept), produce the _Within-Cluster Sum of Squares_ (WCSS) plot and then using the _elbow rule_ the best k can be chosen. The elbow rule is just an empiric method of 	choosing an appropriate k for k-means algorithm. More details about the elbow rule can be found here: https://en.wikipedia.org/wiki/Elbow_method_(clustering)

- The second one named _PCA k-means_ applies clustering using multiple features which can also be chosen by the user. Then _Principal Component Analysis_ is applied and the clusters are plotted using as axes the principal components. Once again the user can decide the proper value of k by producing the WCSS plot and applying the elbow rule.

## References
For the containerization of the app I modified the Dockerfile of this app https://juanitorduz.github.io/dockerize-a-shinyapp/. One of the most straightforward ways to have a Shiny app dockerized.
