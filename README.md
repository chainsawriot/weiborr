# weiborr
Simple Sina Weibo API client

## usage

```{r}
require(weiborr)
require(magrittr)

my_auth <- weibo_auth(access_token = "123")
my_auth %>% weibo_get(api = "statuses/user_timeline", uid = 12345678)
```
