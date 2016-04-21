We can use Apache Bench to benchmark our API service.

Firstly, pull the Apache Bench image:
```
docker pull russmckendrick/ab
```

Next, start a API container:
```
docker-compose up -d <container_name>
# Example
docker-compose up -d go_todo_api
```

Finally, run Apache Bench container to load test your API:
```
docker run --rm --net=vagrant_back russmckendrick/ab ab -k -n <number_request> -c <number_concurrency> <url>:<port>

# Example
eval $(./init.sh | grep config_)
docker run --rm --net=vagrant_back russmckendrick/ab ab -k -n 100 -c 10 http://$config_host:$config_todo_api_gateway_port/

# - A valid url must have / at the end
# - Apache Bench have problem with invalid ssl certificate.
# So you have to use http protocol.
# You can see all arguments of ab by run this command:
docker run --rm russmckendrick/ab ab -h
```

* Please make sure to run Apache Bench container in same network with your API container.


Benchmark result for `go_todo_api` & `php_todo_api` through nginx proxy (`todo_api_gateway`):

* go_todo_api
```
# 443 is internal port of todo_api_gateway for serving go_todo_api
# ab -k -n 10000 -c 100 http://todo_api_gateway:443/
Requests per second:    3977.37 [#/sec] (mean)
```

* php_todo_api
```
# 443 is internal port of todo_api_gateway for serving php_todo_api
# ab -k -n 10000 -c 100 http://todo_api_gateway:443/
Requests per second:    96.04 [#/sec] (mean)
```
