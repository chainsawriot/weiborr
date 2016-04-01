#' @import httr

genURI <- function(api) {
    paste0("https://api.weibo.com/2/", api, ".json")
}

#' @export
weibo_auth <- function(wb_source = NULL, access_token = NULL) {
    if (is.null(wb_source) & is.null(access_token)) {
        stop("Either source or access_token should not be null.")
    }
    if (!is.null(wb_source)) {
        credential <- list(socialmedia = "weibo", wb_source = wb_source)
    } else {
        credential <- list(socialmedia = "weibo", access_token = access_token)
    }
    class(credential) <- append(class(credential), "credential")
    return(credential)
}

#' @export
weibo_get <- function(credential, api = NULL, ...) {
    if (is.null(credential)) {
        stop("Please provide the credential information.")
    }
    if (is.null(api)) {
        stop("Please provide the API to query.")
    }
    if ("wb_source" %in% names(credential)) {
        res <- content(GET(genURI(api), query = list(source = credential$wb_source, ...)))
    } else if ("access_token" %in% names(credential)) {
        res <- content(GET(genURI(api), query = list(access_token = credential$access_token, ...)))
    }
    return(res)
}
