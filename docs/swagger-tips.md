# Swagger tips

## How to use swagger

Expose swagger.yml somewhere in your api, for example "/v1/swagger.yml".

Then start swagger-ui with the yaml file url:

```
eval $(./init.sh | grep config_)
docker run -d --name swagger-ui -p 8888:8888 -e "API_URL=https://$config_host:$config_todo_api_gateway_port/v1/swagger.yml" sjeandeaux/docker-swagger-ui
```
