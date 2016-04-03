# weiborr
Simple Sina Weibo API client

## Philosophy

The purpose of this package is to create a Sina Weibo API client that can adapt to the [ever-changing](http://open.weibo.com/announcement) Sina Weibo API version 2.

The idea is not to create a Weibo API to wrap every API functions. We provide the **fabrics** for you to build your own apps. (Similar to the [Python weibo client](https://github.com/lxyu/weibo).) Therefore, you need to refer to the [API documentation](http://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9AAPI).

## Usage

```{r}
require(weiborr)
require(magrittr)

my_auth <- weibo_auth(access_token = "123")
my_auth %>% weibo_get(api = "statuses/user_timeline", uid = 12345678)
```
