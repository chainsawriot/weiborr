#' @import httr
#' @import plyr

gen_uri <- function(api) {
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
weibo_get <- function(credential, api = "friendships/friends", ..., ignore_weibo_error = TRUE) {
    if (is.null(credential)) {
        stop("Please provide the credential information.")
    }
    if (is.null(api)) {
        stop("Please provide an API to query.")
    }
    if ("wb_source" %in% names(credential)) {
        res <- content(GET(gen_uri(api), query = list(source = credential$wb_source, ...)))
    } else if ("access_token" %in% names(credential)) {
        res <- content(GET(gen_uri(api), query = list(access_token = credential$access_token, ...)))
    }
    if ("error" %in% names(res)) {
        res <- make_class(res, "weibo_error")
        if (!ignore_weibo_error) {
            stop(paste0("API error, error msg: ", res$error))
        }
        return(res)
    }

    if ("users" %in% names(res)) {
        res <- gen_multiple_weibo_users(res)
    }
    if ('statuses' %in% names(res)) {
        res <- gen_multiple_weibo_statuses(res)
    }
    if (api == 'users/show') {
        res <- make_class(res, "weibo_user")
        if ("status" %in% names(res)) {
            res$status <- make_weibo_status(res$status)
        }
    }
    if (api == 'statuses/show') {
        res <- make_weibo_status(res)
    }
    return(res)
}
