FROM rocker/shiny-verse:3.6.3
RUN apt-get update && apt-get install -y  git-core imagemagick libcurl4-openssl-dev libgeos-dev libgeos++-dev libgit2-dev libicu-dev libmagic-dev libmagick++-dev libssh2-1-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.4.2")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.0.0")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.2")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3")'
RUN Rscript -e 'remotes::install_version("whereami",upgrade="never", version = "0.1.9")'
RUN Rscript -e 'remotes::install_version("viridis",upgrade="never", version = "0.5.1")'
RUN Rscript -e 'remotes::install_version("shinyWidgets",upgrade="never", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("shinyjs",upgrade="never", version = "1.0")'
RUN Rscript -e 'remotes::install_version("processx",upgrade="never", version = "3.4.4")'
RUN Rscript -e 'remotes::install_version("rlang",upgrade="never", version = "0.4.8")'
RUN Rscript -e 'remotes::install_version("magick",upgrade="never", version = "2.2")'
RUN Rscript -e 'remotes::install_version("ggvoronoi",upgrade="never", version = "0.8.3")'
RUN Rscript -e 'remotes::install_github("r-lib/later@0cfd3b5dd3eb842a05952d8caa89b48cbf05bc42")'
RUN Rscript -e 'remotes::install_github("rstudio/promises@bbadb3d7dedfc052813bb66b4b1dcfebd5ff881a")'
RUN Rscript -e 'remotes::install_github("r-lib/gitcreds@50a1608b5728598f1c281c5aea6091740538f762")'
RUN Rscript -e 'remotes::install_github("r-lib/rprojroot@5bafca9bc96d57d81045ff1b3b361a926b6b93bf")'
RUN Rscript -e 'remotes::install_github("r-lib/gh@e936ee46ea6719bff963c2e331e7cbbb9613ef95")'
RUN Rscript -e 'remotes::install_github("r-lib/desc@c1752592643466041bf6169eb1aff0366cf00bd1")'
RUN Rscript -e 'remotes::install_github("r-lib/usethis@2a7ee3b59f8b68e0a6a85e393f8fa320e05020f6")'
RUN Rscript -e 'remotes::install_github("r-lib/here@fdd23b1450518bbf7e8bb92fb7c6dc370bb0552b")'
RUN Rscript -e 'remotes::install_github("thinkr-open/golem@aaae5c8788802a7b4aef4df23691902a286dd964")'

ARG GH_PAT
ENV GITHUB_PAT=$GH_PAT

# expose port (for local deployment only)
EXPOSE 3838

RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone

RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone

# set non-root
RUN useradd shiny_user
USER shiny_user

CMD R -e "options('shiny.port'=$PORT,shiny.host='0.0.0.0');puzzlemath::run_app()"
