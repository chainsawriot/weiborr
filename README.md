# weiborr
Simple Sina Weibo API client

## Philosophy

The purpose of this package is to create a Sina Weibo API client that can adapt to the [ever-changing](http://open.weibo.com/announcement) Sina Weibo API version 2.

The idea is not to create a Weibo API to wrap every API functions. We provide the **fabric** for you to build your own application. (Similar to the [Python weibo client](https://github.com/lxyu/weibo).) Therefore, you still need to refer to the [Official API documentation](http://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9AAPI).

## Usage

```{r}
require(weiborr)
require(magrittr)

my_auth <- weibo_auth(access_token = "123")
frds <- weibo_get(my_auth, api = "friendships/friends", uid = 12345678)
to_df(frds$users) ## convert multiple users info to data.frame
```
