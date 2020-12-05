# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:4.0.3

LABEL author="Jonathan Sidi https://hub.docker.com/u/yonicd" 

# system libraries of general use
# install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libmagick++-dev
    #libcairo2-dev \
    #libpq-dev \
    #libssh2-1-dev \
    #libcurl4-openssl-dev \
    #libssl-dev

RUN ldconfig /usr/local/lib

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# copy necessary files
## app folder
#COPY /shiny_geocode ./app
## renv.lock file
#COPY /renv.lock ./renv.lock

# install renv & restore packages
RUN Rscript -e 'install.packages(c("remotes","shinyjs","magick"))'
RUN Rscript -e 'remotes::install_github("yonicd/puzzlemath@voronoi")'

# remove install files
RUN rm -rf /var/lib/apt/lists/*

# make all app files readable, gives rwe permisssion (solves issue when dev in Windows, but building in Ubuntu)
# RUN chmod -R 755 /app

# expose port (for local deployment only)
EXPOSE 3838 

# set non-root
RUN useradd shiny_user
USER shiny_user

#as.numeric(Sys.getenv('PORT'))
# run app on container start (use heroku port variable for deployment)
CMD ["R", "-e", "library('puzzlemath');options('shiny.host' = '0.0.0.0', 'shiny.port' = 3838L);puzzlemath::run_app()"]
