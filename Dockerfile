# get shiny serves plus tidyverse packages image
FROM rocker/shiny-verse:latest

COPY src/ /srv/shiny-server/
# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev 

# (change it dependeing on the packages you need)
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('shinyWidgets', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('caret', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('cluster', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('factoextra', repos='http://cran.rstudio.com/')"


# copy the app to the image
# COPY src/server.R /srv/shiny-server/
# COPY src/ui.R /srv/shiny-server/


# select port
EXPOSE 3838

# allow permission
RUN sudo chown -R shiny:shiny /srv/shiny-server

# run app
CMD ["/usr/bin/shiny-server.sh"]

# docker build -t my-shiny-app .

# docker run --rm -p 3838:3838 my-shiny-app