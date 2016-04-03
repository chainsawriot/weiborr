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

print.multiple_weibo_users <- function(obj) {
    cat("A collection of", length(obj), "weibo user(s).\n")
}

print.weibo_user <- function(obj) {
    cat("A weibo user with id #", obj$id, ".\n")
}

to_df <- function(obj) {
    UseMethod("to_df")
}

to_df.weibo_user <- function(obj) {
    as.data.frame.list(obj, stringsAsFactors = FALSE)
}

to_df.multiple_weibo_users <- function(obj) {
    return(plyr::ldply(obj, to_df))
}

gen_multiple_weibo_users <- function(frds) {
    if (!"users" %in% (names(frds))) {
        stop("Not a API result from a 'friendships/...' query.")
    }
    frds$users <- plyr::llply(frds$users, function(x) make_class(x, "weibo_user"))
    frds$users <- make_class(frds$users, "multiple_weibo_users")
    return(frds)
}

#### ERROR

print.weibo_error <- function(obj) {
    cat("Weibo error, error code:", obj$error_code, ".\n")
}
