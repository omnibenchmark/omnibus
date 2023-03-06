#' Function to create a config file for Omnibenchmark setup
#' 
#' @param benchmark Name of the benchmark
#' @param datasets The number of datasets to add to the config
#' @param datanames The names of the datasets to add
#' @param methods The number of methods to add to the config
#' @param methodnames The names of the methods to add
#' @param metrics The number of metrics to add to the config
#' @param methodnames The names of the metrics to add
#' @param explainer Boolean. If TRUE, adds explanations of each config parameter to the config file
#' @usage create_config("my_benchmark", datanames = c("data1", "data2"), methodnames = c("method1", "method2"), explainer = TRUE)
#'
create_config <- function(
        benchmark,
        datasets = NULL, 
        datanames = NULL,
        methods = NULL,
        methodnames = NULL,
        metrics = NULL,
        metricnames = NULL,
        explainer = FALSE,
        ...
){
    # check arguments
    used_args = c("NAMESPACE_ID", "GROUPNAME", "DIR", "TEMSOURCE", "TEMREF", "VISIBILITY", "GLUSERNAME", "USEREMAIL", "token")
    arg_list <- as.list(match.call()[-1])
    function_arg_list <- names(as.list(formals()))
    
    if(!all((names(arg_list) %in% c(used_args, function_arg_list)))) {
        forbidden_args <- names(arg_list)[!(names(arg_list) %in% c(used_args, function_arg_list))]
        stop(paste("The following arguments were not understood:", paste(forbidden_args, collapse = ", "), 
                   "\n please only use the function arguments:",
                   paste(function_arg_list, collapse = ", "),
                    "and those in the config template:\n", 
                   paste(used_args, collapse = ", ")))
    }
    
    REPONAMES <- "REPONAMES=("
    KEYWORDS <- "KEYWORDS=("
    TEMPLATES <- "TEMPLATES=("
    # Datasets
    if(!is.null(datasets) | !is.null(datanames)) {
        if(is.null(datasets)) {datasets <- length(datanames)}
        if(is.null(datanames)) datanames <- c()
        datasets <- max(datasets, length(datanames))
        if(datasets > length(datanames)) datanames <- c(datanames, rep("EDIT", datasets - length(datanames)))
        
        
        REPONAMES <- paste0(REPONAMES,
                            paste0(rep('"dataset_', datasets), datanames, '"', collapse = ' '))
        KEYWORDS <- paste0(KEYWORDS,
                            paste0('"', rep(benchmark, datasets), '_dataset"', collapse = ' '))
        TEMPLATES <- paste0(TEMPLATES,
                           paste0(rep('"omni-data-py', datasets), '"', collapse = ' '))
    }
    # Methods
    if(!is.null(methods) | !is.null(methodnames)) {
        if(is.null(methods)) {methods <- length(methodnames)}
        if(is.null(methodnames)) methodnames <- c()
        methods <- max(methods, length(methodnames))
        if(methods > length(methodnames)) methodnames <- c(methodnames, rep("EDIT", methods - length(methodnames)))
        
        REPONAMES <- paste0(REPONAMES, " ",
                            paste0(rep('"method_', methods), methodnames, '"', collapse = ' '))
        KEYWORDS <- paste0(KEYWORDS, " ",
                           paste0('"', rep(benchmark, methods), '_method"', collapse = ' '))
        TEMPLATES <- paste0(TEMPLATES, " ",
                           paste0(rep('"omni-method-py', methods), '"', collapse = ' '))
    }
    # Metrics
    if(!is.null(metrics) | !is.null(metricnames)) {
        if(is.null(metrics)) {metrics <- length(metricnames)}
        if(is.null(metricnames)) metricnames <- c()
        metrics <- max(metrics, length(metricnames))
        if(metrics > length(metricnames)) metricnames <- c(metricnames, rep("EDIT", metrics - length(metricnames)))
        
        
        REPONAMES <- paste0(REPONAMES, " ",
                            REPONAMES_met <- paste0(rep('"metric_', metrics), metricnames, '"', collapse = ' '))
        KEYWORDS <- paste0(KEYWORDS, " ",
                           paste0('"', rep(benchmark, metrics), '_metric"', collapse = ' '))
        TEMPLATES <- paste0(TEMPLATES, " ",
                           paste0(rep('"omni-metric-py', metrics), '"', collapse = ' '))
    }
    REPONAMES <- paste0(REPONAMES, ")")
    if(REPONAMES == "REPONAMES=()") REPONAMES <- "REPONAMES=() # EDIT HERE"
    KEYWORDS <- paste0(KEYWORDS, ")")
    if(KEYWORDS == "KEYWORDS=()") KEYWORDS <- "KEYWORDS=() # EDIT HERE"
    TEMPLATES <- paste0(TEMPLATES, ")")
    if(TEMPLATES == "TEMPLATES=()") TEMPLATES <- "TEMPLATES=() # EDIT HERE"
    

    
    # Define optional params
    # These will only be filled if they were provided in the function call
    NAMESPACE_ID <- ifelse(!is.null(arg_list$NAMESPACE_ID), paste0(arg_list$NAMESPACE_ID, '"'), 'Namspace_ID" # EDIT HERE')
    GROUPNAME <- ifelse(!is.null(arg_list$GROUPNAME), paste0(arg_list$GROUPNAME, '"'), 'My_benchmark_group" # EDIT HERE')
    DIR <- ifelse(!is.null(arg_list$DIR), paste0(arg_list$DIR, '"'), '/root/omb/${BENCHMARK}" # EDIT HERE')
    PTITLES <- ifelse(!is.null(arg_list$PTITLES), paste0(arg_list$PTITLES, '"'), '"${REPONAMES}"')
    TEMSOURCE <- ifelse(!is.null(arg_list$TEMSOURCE), paste0(arg_list$TEMSOURCE, '"'), 'https://github.com/omnibenchmark/contributed-project-templates"')
    TEMREF <- ifelse(!is.null(arg_list$TEMREF), paste0(arg_list$TEMREF, '"'), 'CLI_main"')
    VISIBILITY <- ifelse(!is.null(arg_list$VISIBILITY), paste0(arg_list$VISIBILITY, '"'), 'public/private" # EDIT HERE')
    GLUSERNAME <- ifelse(!is.null(arg_list$GLUSERNAME), paste0(arg_list$GLUSERNAME, '"'), 'YourGLName" # EDIT HERE')
    USEREMAIL <- ifelse(!is.null(arg_list$USEREMAIL), paste0(arg_list$USEREMAIL, '"'), 'name@email.com" # EDIT HERE')
    token <- ifelse(!is.null(arg_list$token), paste0(arg_list$token, '"'), 'glpat-blabla" # EDIT HERE')
    
    # Add explanation
    explainer_message <- ""
    if(explainer){
        explainer_message <- '\n
# Explainations:
# REPONAMES, TEMPLATES, KEYWORDS, and PTITLES must have the same length!
# 
# BENCHMARK: Sets the name of the benchmark you are setting up
# NAMESPACE_ID: The ID of the group you have made (please make the group beforehand)
# GROUPNAME: The name of the group you created
# DIR: Path to where you would like the template repos to be created on your system 
# REPONAMES: The project names for each benchmark component (do not include the orcestrator or parameters)
# PTITLES: The titles for each project.
# KEYWORDS: The keywords to assign each project that lets omnibenchmark refer to them
# TEMPLATES: (options: "omni-data-py" "omni-method-py" "omni-metric-py" "omni-param-py" "omni-processed-py")
# TEMSOURCE: The link to a repository of GitLab templates
# TEMREF: The branch for the template 
# VISIBILITY: The visibility of your projects
# GLUSERNAME: Your GitLab username
# USEREMAIL:  Your GitLab email
# token: A token with `api` scope at renkulab.io\'s gitlab'
    }
    
    
    # Write the config file
    # 
    readr::write_file(
      paste(
          "#!/bin/bash", # shebang
          paste("# Configuration of", benchmark),
          "# ",
          "# ",
          paste0('BENCHMARK="', benchmark, '"'),
          paste0('NAMESPACE_ID="', NAMESPACE_ID),
          paste0('GROUPNAME="',GROUPNAME),
          paste0('DIR="',DIR),
          REPONAMES,
          paste0('PTITLES="', PTITLES),
          KEYWORDS,
          TEMPLATES,
          paste0('TEMSOURCE="', TEMSOURCE),
          paste0('TEMREF="', TEMREF),
          paste0('VISIBILITY="', VISIBILITY),
          paste0('GLUSERNAME="', GLUSERNAME),
          paste0('USEREMAIL="', USEREMAIL),
          paste0('token="', token),
          explainer_message,
          sep ='\n'
          ),
      file = paste0('config_', benchmark)
      )
    # cat(content)
    # system(paste("cat", content, ">", paste0('config_', benchmark)))
    
    cat("Config stored at '", getwd(), "/config_", benchmark, "' Make sure to edit the config where indicated", sep = "")
    
}


if(FALSE){
    
    create_config(
        benchmark = "my_new_benchmark",
        datasets = 5,
        datanames = NULL,
        methods = 2,
        methodnames = NULL,
        metrics = 3,
        metricnames = c("ARI", "NID"),
        explainer = TRUE,
        token = "testtoken",
        VISIBILITY = "private")
    
}