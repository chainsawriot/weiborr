## reference: http://open.weibo.com/wiki/%E5%B8%B8%E8%A7%81%E8%BF%94%E5%9B%9E%E5%AF%B9%E8%B1%A1%E6%95%B0%E6%8D%AE%E7%BB%93%E6%9E%84

## proposed S3 classes:
## 1. weibo_user
## 2. weibo_status
## 3. multiple_weibo_users
## 4. multiple_weibo_statuses
## 5. weibo_error

make_class <- function(x, which_class) {
    class(x) <- append(class(x), which_class)
    return(x)
}

## weibo_status

print.multiple_weibo_statuses <- function(obj) {
    cat("Collection of", length(obj), "weibo status(es).\n")
}

print.weibo_status <- function(obj) {
    if (nchar(obj$text) > 10) {
        preview <- paste0(substr(obj$text, 1, 10), "...")
    } else {
        preview <- obj$text
    }
    cat("Weibo status: ", obj$mid, ". Preview:", preview, "\n")
    if (!is.null(obj$retweeted_status)) {
        cat("A retweet of weibo status: ", obj$mid, "\n")
    }
}


gen_multiple_weibo_statuses <- function(res) {
    if (!"statuses" %in% (names(res))) {
        stop("Not a API result from a 'statuses/...' query.")
    }
    res$statuses <- plyr::llply(res$statuses, make_weibo_status)
    res$statuses <- make_class(res$statuses, "multiple_weibo_statuses")
    return(res)
}

make_weibo_status <- function(obj) {
    if (!is.null(obj$user)) {
        obj$user <- make_class(obj$user, "weibo_user")
    }
    if (!is.null(obj$retweeted_status)) {
        obj$retweeted_status <- make_weibo_status(obj$retweeted_status)
    }
    obj <- make_class(obj, "weibo_status")
    return(obj)
}

## weibo_user and multiple_weibo_users

print.multiple_weibo_users <- function(obj) {
    cat("Collection of", length(obj), "weibo user(s).\n")
}

print.weibo_user <- function(obj) {
    if (!"status" %in% names(obj)) {
        cat("Weibo user: id", obj$id, ".\n")
    } else {
        cat("Weibo user: id", obj$id, ". With embeded status.\n")
    }
}

to_df <- function(obj) {
    UseMethod("to_df")
}

to_df.weibo_user <- function(obj) {
    if (!'status' %in% names(obj)) {
        return(as.data.frame.list(obj, stringsAsFactors = FALSE))
    } else {
        warning("Status in the weibo_user object removed.")
        return(as.data.frame.list(obj[names(obj) != "status"], stringsAsFactors = FALSE))
    }
}

to_df.multiple_weibo_users <- function(obj) {
    return(plyr::ldply(obj, to_df))
}

gen_multiple_weibo_users <- function(res) {
    if (!"users" %in% (names(res))) {
        stop("Not a API result from a 'friendships/...' query.")
    }
    res$users <- plyr::llply(res$users, function(x) make_class(x, "weibo_user"))
    res$users <- make_class(res$users, "multiple_weibo_users")
    return(res)
}

#### weibo_error

print.weibo_error <- function(obj) {
    cat("Weibo error, error code:", obj$error_code, ".\n")
}
