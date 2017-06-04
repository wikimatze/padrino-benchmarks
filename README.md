# Padrino Component Benchmarks

The goal of this project is to measure the different components you can use with Padrino.
Currently the different renderer and orms are benchmarked.


For benchmarking [Padrino version 0.14.1.1](https://github.com/padrino/padrino-framework/releases/tag/0.14.1.1)
is used with [ruby 2.3.1p112](https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz), and [WEBrick 1.3.1](https://rubygems.org/gems/webrick/versions/1.3.1 "WEBrick 1.3.1"). The versions of the components are described in the headers.


## Toc

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Overview Results](#overview-results)
  - [Renderer](#renderer)
  - [Orms](#orms)
- [Detailed Results](#detailed-results)
  - [Renderer](#renderer-1)
    - [haml (5.0.1)](#haml-501)
    - [erb (erubi 1.6.0)](#erb-erubi-160)
    - [slim (3.0.8)](#slim-308)
    - [liquid (4.0.0)](#liquid-400)
  - [Orms](#orms-1)
    - [Activerecord (5.1.1)](#activerecord-511)
    - [Couchrest (1.1.0)](#couchrest-110)
    - [Mongoid (6.1.0)](#mongoid-610)
    - [Ohm (1.3.0)](#ohm-130)
    - [Sequel (4.47.0)](#sequel-4470)

## Installation

```sh
$ git clone https://github.com/padrino/benchmark.git
```


Now you need to run the `install` script withtin the repository which installs the dependencies.

Next you need to install [wrk](https://github.com/wg/wrk "wrk - a HTTP benchmarking tool") - modern HTTP benchmarking tool:


```sh
$ git clone https://github.com/wg/wrk.git && cd wrk && make && sudo cp wrk /usr/local/bin
```


## Usage

```sh
$ ./benchmark renderer
$ ./benchmark orms
```

Please that you need to have
[redis](https://redis.io/ "redis"), [Mongo-db](https://www.mongodb.com/ "Mongo-db"), [couchdb](http://couchdb.apache.org/ "couchdb")
installed and running on your local machine when running `$ ./benchmark orms`


## Configuration

You can change the duration, number of threads, and number of connection for the benchmark by changing the constant
values (`BENCHMARK_THREADS`, `BENCHMARK_DURATION`, `BENCHMARK_CONNECTIONS`) in the `benchmark` file.


## Overview Results


### Renderer

Generation:

```sh
$ padrino g project <render-name>-app -e <render-name>
$ padrino g controller render get:index
```


Template:

```html
<h2>Hello</h2>
<strong>world</strong>
```

The template may vary depending on the used render method.


#### 1 thread, 1 connection, 10 seconds

| Render        | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------- | ------------- | -------------------| ------- | ------------
| erubi (1.6.0) | 40.49ms       | 247                | 24.69   | 20.52KB
| liquid (4.0.0)| 40.66ms       | 245                | 24.50   | 20.39KB
| haml (5.0.1)  | 41.30ms       | 242                | 24.17   | 20.09KB
| slim (3.0.8)  | 44.03ms       | 227                | 22.67   | 18.78KB


#### 1 thread, 10 connection, 10 seconds

| Orm           | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------- | ------------- | -------------------| ------- | ------------
| erubi (1.6.0) | 42.47ms       | 2350               | 234.98  | 195.23KB
| liquid (4.0.0)| 42.34ms       | 2358               | 235.80  | 195.97KB
| haml (5.0.1)  | 44.78ms       | 2230               | 222.96  | 185.27KB
| slim (3.0.8)  | 66.75ms       | 1504               | 149.85  | 123.90KB


#### 1 thread, 100 connection, 10 seconds

| Orm           | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------- | ------------- | -------------------| ------- | ------------
| erubi (1.6.0) | 202.03ms      | 4940               | 493.62  | 409.65KB
| liquid (4.0.0)| 260.33ms      | 3841               | 382.91  | 318.73KB
| haml (5.0.1)  | 264.57ms      | 3788               | 378.55  | 378.55KB
| slim (3.0.8)  | 479.58ms      | 2041               | 203.59  | 168.56KB


#### 1 thread, 10000 connection, 10 seconds

| Orm           | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------- | ------------- | -------------------| ------- | ------------
| erubi (1.6.0) | 264.45ms      | 3730               | 370.98  | 308.48KB
| haml (5.0.1)  | 299.76ms      | 3286               | 326.88  | 271.09KB
| liquid (4.0.0)| 285.50ms      | 3448               | 343.26  | 285.46KB
| slim (3.0.8)  | 364.22ms      | 2716               | 269.66  | 222.52KB


### Orms

Generation:

```sh
$ padrino g project <orm-name>-app -d <orm-name> -a sqlite -e erb
$ padrino g model post name:string text:string
$ padrino g controller orm get:posts
```


Controller Action:

```ruby
get :posts, :map => '/' do
  @post = Post.first # this may vary for the corresponding orm, e.g. Post[1] for ohm (redis)
  render 'posts'
end
```


Template:

```erb
<%= @post.name %> <%= @post.text %>
```


#### 1 thread, 1 connection, 10 seconds

| Orm                 | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------------- | ------------- | -------------------| ------- | ------------
| activerecord (5.1.1)| 41.82ms       | 241                | 23.86   | 23.86KB
| couchrest (1.1.0)   | 44.02ms       | 227                | 22.67   | 18.30KB
| mongoid (6.1.0)     | 41.82ms       | 241                | 23.86   | 19.23KB
| ohm (1.3.0)         | 40.99ms       | 243                | 24.30   | 195.86KB
| sequel (4.47.0)     | 40.87ms       | 244                | 24.39   | 196.90KB
| mongomatic          | ???           | ???                | ???     | ???
| ripple              | ???           | ???                | ???     | ???
| dynamoid            | ???           | ???                | ???     | ???
| datamapper          | ???           | ???                | ???     | ???


#### 1 thread, 10 connection, 10 seconds

| Orm                 | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------------- | ------------- | -------------------| ------- | ------------
| activerecord (5.1.1)| 47.85ms       | 2089               | 208.58  | 168.22KB
| couchrest (1.1.0)   | 50.45ms       | 1978               | 197.66  | 159.57KB
| mongoid (6.1.0)     | 47.09ms       | 2121               | 211.91  | 170.86KB
| ohm (1.3.0)         | 44.66ms       | 2235               | 223.43  | 179.90KB
| sequel (4.47.0)     | 44.21ms       | 2259               | 225.85  | 182.23KB
| mongomatic          | ???           | ???                | ???     | ???
| ripple              | ???           | ???                | ???     | ???
| dynamoid            | ???           | ???                | ???     | ???
| datamapper          | ???           | ???                | ???     | ???


#### 1 thread, 100 connection, 10 seconds

| Orm                 | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------------- | ------------- | -------------------| ------- | ------------
| activerecord (5.1.1)| 360.29ms      | 2761               | 275.82  | 222.28KB
| couchrest (1.1.0)   | 426.91ms      | 2312               | 230.87  | 186.34KB
| mongoid (6.1.0)     | 379.77ms      | 2602               | 259.80  | 209.44KB
| ohm (1.3.0)         | 320.79ms      | 3119               | 311.62  | 251.01KB
| sequel (4.47.0)     | 321.08ms      | 3275               | 327.28  | 263.19KB
| mongomatic          | ???           | ???                | ???     | ???
| ripple              | ???           | ???                | ???     | ???
| dynamoid            | ???           | ???                | ???     | ???
| datamapper          | ???           | ???                | ???     | ???


#### 1 thread, 10000 connection, 10 seconds

| Orm                 | Avg Latency   | Number of Requests | Req/Sec | Transfer/sec
| ------------------- | ------------- | -------------------| ------- | ------------
| activerecord (5.1.1)| 415.18ms      | 2359               | 235.08  | 189.49KB
| couchrest (1.1.0)   | 424.09ms      | 2290               | 227.36  | 186.32KB
| mongoid (6.1.0)     | 419.89ms      | 2330               | 231.50  | 187.24KB
| ohm (1.3.0)         | 289.12ms      | 3407               | 339.31  | 274.58KB
| sequel (4.47.0)     | 302.01ms      | 3245               | 323.34  | 260.51KB
| mongomatic          | ???           | ???                | ???     | ???
| ripple              | ???           | ???                | ???     | ???
| dynamoid            | ???           | ???                | ???     | ???
| datamapper          | ???           | ???                | ???     | ???



## Detailed Results

### Renderer

Generation:

```sh
$ padrino g project <render-name>-app -e <render-name>
$ padrino g controller render get:index
```


Template:

```html
<h2>Hello</h2>
<strong>world</strong>
```

The template may vary depending on the used render method.


#### haml (5.0.1)
Template:

```haml
%h2= "Hello"
%strong= "world"
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    41.30ms    3.13ms  51.98ms   93.80%
  Req/Sec    24.17      4.93    30.00     60.00%
242 requests in 10.01s, 201.20KB read
Requests/sec:     24.17
Transfer/sec:     20.09KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    44.78ms    5.63ms 104.60ms   89.48%
  Req/Sec   223.92     20.79   252.00     81.00%
2230 requests in 10.00s, 1.81MB read
Requests/sec:    222.96
Transfer/sec:    185.27KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   264.57ms  117.88ms 962.94ms   76.73%
  Req/Sec   380.39     94.92   575.00     72.00%
3788 requests in 10.01s, 3.07MB read
Requests/sec:    378.55
Transfer/sec:    314.36KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   299.76ms  128.02ms 919.98ms   73.19%
  Req/Sec   337.69     93.95   540.00     68.75%
3286 requests in 10.05s, 2.66MB read
Socket errors: connect 8980, read 0, write 0, timeout 0
Requests/sec:    326.88
Transfer/sec:    271.09KB
```


#### erb (erubi 1.6.0)
Template:

```erb
<h2>Hello</h2>
<strong>world</strong>
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    40.49ms    2.42ms  47.91ms   85.02%
  Req/Sec    24.70      5.02    30.00     53.00%
247 requests in 10.00s, 205.34KB read
Requests/sec:     24.69
Transfer/sec:     20.52KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
1 threads and 10 connections
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    42.47ms    3.65ms  74.93ms   88.81%
  Req/Sec   235.99     18.56   262.00     85.00%
2350 requests in 10.00s, 1.91MB read
Requests/sec:    234.98
Transfer/sec:    195.23KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   202.03ms   81.46ms 680.11ms   71.40%
  Req/Sec   496.08     93.73   650.00     69.00%
4940 requests in 10.01s, 4.00MB read
Requests/sec:    493.62
Transfer/sec:    409.65KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   264.45ms   85.66ms 879.83ms   75.36%
  Req/Sec   374.46     95.26     0.95k    79.00%
3730 requests in 10.05s, 3.03MB read
Socket errors: connect 8980, read 0, write 0, timeout 0
Requests/sec:    370.98
Transfer/sec:    308.48KB
```


#### slim (3.0.8)

Template:


```slim
h2 Hello
strong welt
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    44.03ms    1.72ms  48.28ms   95.59%
  Req/Sec    22.68      4.45    30.00     73.00%
227 requests in 10.02s, 188.11KB read
Requests/sec:     22.67
Transfer/sec:     18.78KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    66.75ms   18.28ms 179.99ms   67.04%
  Req/Sec   150.44     27.93   210.00     70.00%
1504 requests in 10.04s, 1.21MB read
Requests/sec:    149.85
Transfer/sec:    123.90KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   479.58ms  176.85ms   1.74s    71.73%
  Req/Sec   204.44     81.66   676.00     85.00%
2041 requests in 10.02s, 1.65MB read
Requests/sec:    203.59
Transfer/sec:    168.56KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   364.22ms  184.56ms   1.59s    78.57%
  Req/Sec   276.92    113.09   690.00     68.37%
2716 requests in 10.07s, 2.19MB read
Socket errors: connect 8980, read 61, write 0, timeout 0
Requests/sec:    269.66
Transfer/sec:    222.52KB
```


#### liquid (4.0.0)

Template:

```html
<h2>Hello</h2>
<strong>world</strong>
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    40.66ms    2.02ms  47.99ms   84.90%
  Req/Sec    24.50      5.00    30.00     55.00%
245 requests in 10.00s, 203.92KB read
Requests/sec:     24.50
Transfer/sec:     20.39KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    42.34ms    3.62ms  68.01ms   88.89%
  Req/Sec   236.75     15.90   272.00     79.00%
2358 requests in 10.00s, 1.91MB read
Requests/sec:    235.80
Transfer/sec:    195.97KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   260.33ms  111.10ms 899.40ms   69.30%
  Req/Sec   384.86    138.18   650.00     66.00%
3841 requests in 10.03s, 3.12MB read
Requests/sec:    382.91
Transfer/sec:    318.73KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   285.50ms  123.30ms   1.22s    69.34%
  Req/Sec   345.69    139.27   690.00     65.00%
3448 requests in 10.04s, 2.80MB read
Socket errors: connect 8980, read 169, write 0, timeout 0
Requests/sec:    343.26
Transfer/sec:    285.46KB
```


### Orms

Generation:

```sh
$ padrino g project <orm-name>-app -d <orm-name> -a sqlite -e erb
$ padrino g model post name:string text:string
$ padrino g controller orm get:posts
```


Controller Action:


```ruby
get :posts, :map => '/' do
  @post = Post.first # this may vary for the corresponding orm, e.g. Post[1] for ohm (redis)
  render 'posts'
end
```


Template:

```erb
<%= @post.name %> <%= @post.text %>
```


#### Activerecord (5.1.1)

sqlite: 3.8.2

DB setup:

```sh
$ padrino rake db:create
$ padrino rake db:migrate
$ echo "Post.create(name: \"Hello\", text: \"world\")" > db/seeds.rb
$ padrino rake db:seed
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    41.82ms    2.21ms  48.03ms   92.95%
  Req/Sec    23.86      4.89    30.00     61.39%
241 requests in 10.10s, 194.25KB read
Requests/sec:     23.86
Transfer/sec:     19.23KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    47.85ms    8.87ms 115.65ms   89.84%
  Req/Sec   209.59     25.74   252.00     78.00%
2089 requests in 10.02s, 1.65MB read
Requests/sec:    208.58
Transfer/sec:    168.22KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   360.29ms  103.06ms   1.11s    91.27%
  Req/Sec   277.04     45.64   370.00     79.00%
2761 requests in 10.01s, 2.17MB read
Requests/sec:    275.82
Transfer/sec:    222.28KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   415.18ms   31.69ms 632.82ms   82.45%
  Req/Sec   240.10     31.65   290.00     70.41%
2359 requests in 10.03s, 1.86MB read
Socket errors: connect 8980, read 393, write 0, timeout 0
Requests/sec:    235.08
Transfer/sec:    189.49KB
```


#### Couchrest (1.1.0)

On couchdb 1.6.1

DB setup:


```sh
$ echo "Post.create(name: \"Hello\", text: \"world\")" > db/seeds.rb
$ padrino rake db:seed
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    44.02ms    1.40ms  51.32ms   97.36%
  Req/Sec    22.69      4.47    30.00     73.00%
227 requests in 10.01s, 183.23KB read
Requests/sec:     22.67
Transfer/sec:     18.30KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    50.45ms    7.27ms 105.58ms   90.51%
  Req/Sec   198.59     24.41   232.00     83.00%
1978 requests in 10.01s, 1.56MB read
Requests/sec:    197.66
Transfer/sec:    159.57KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   426.91ms  175.77ms   1.31s    75.64%
  Req/Sec   231.91    119.36     0.99k    78.00%
2312 requests in 10.01s, 1.82MB read
Requests/sec:    230.87
Transfer/sec:    186.34KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   424.09ms  179.87ms   1.39s    76.24%
  Req/Sec   235.72    128.51   525.00     66.67%
2290 requests in 10.07s, 1.82MB read
Socket errors: connect 8980, read 0, write 0, timeout 0
Requests/sec:    227.36
Transfer/sec:    185.32KB
```


#### Mongoid (6.1.0)

Mongo-db version v2.4.9

DB setup:


```sh
$ echo "Post.create(name: \"Hello\", text: \"world\")" > db/seeds.rb
$ padrino rake db:seed
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    41.82ms    2.21ms  48.03ms   92.95%
  Req/Sec    23.86      4.89    30.00     61.39%
241 requests in 10.10s, 194.25KB read
Requests/sec:     23.86
Transfer/sec:     19.23KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    47.09ms    6.83ms 100.03ms   79.39%
  Req/Sec   212.81     21.98   242.00     79.00%
2121 requests in 10.01s, 1.67MB read
Requests/sec:    211.91
Transfer/sec:    170.86KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   379.77ms  157.88ms   1.58s    75.19%
  Req/Sec   261.15    119.36   770.00     65.00%
2602 requests in 10.02s, 2.05MB read
Requests/sec:    259.80
Transfer/sec:    209.44KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   419.89ms  203.47ms   1.70s    79.61%
  Req/Sec   236.93    110.74   490.00     68.37%
2330 requests in 10.06s, 1.84MB read
Socket errors: connect 8980, read 58, write 0, timeout 0
Requests/sec:    231.50
Transfer/sec:    187.24KB
```


#### Ohm (1.3.0)

redis v3.2.9

DB setup:


```sh
$ echo "Post.create(name: \"Hello\", text: \"world\")" > db/seeds.rb
$ padrino rake db:seed
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    40.99ms    2.95ms  60.22ms   79.42%
  Req/Sec    24.30      4.98    30.00     57.00%
243 requests in 10.00s, 195.86KB read
Requests/sec:     24.30
Transfer/sec:     19.58KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    44.66ms    3.93ms  84.03ms   71.50%
  Req/Sec   224.41     16.41   252.00     78.00%
2235 requests in 10.00s, 1.76MB read
Requests/sec:    223.43
Transfer/sec:    179.90KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   320.79ms  132.31ms   1.19s    81.27%
  Req/Sec   313.06     86.38   683.00     81.00%
3119 requests in 10.01s, 2.45MB read
Requests/sec:    311.62
Transfer/sec:    251.01KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   289.12ms  118.02ms 999.96ms   72.32%
  Req/Sec   342.14    126.94   616.00     69.00%
3407 requests in 10.04s, 2.69MB read
Socket errors: connect 8980, read 0, write 0, timeout 0
Requests/sec:    339.31
Transfer/sec:    274.58KB
```


#### Sequel (4.47.0)

sqlite: 3.8.2

DB setup:

```sh
$ echo "Post.create(name: \"Hello\", text: \"world\")" > db/seeds.rb
$ padrino rake sq:reset
```


**Results: 1 thread, 1 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    40.87ms    2.49ms  48.41ms   77.87%
  Req/Sec    24.40      4.99    30.00     56.00%
244 requests in 10.00s, 196.90KB read
Requests/sec:     24.39
Transfer/sec:     19.68KB
```


**Results: 1 thread, 10 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency    44.21ms    5.23ms 104.72ms   91.87%
  Req/Sec   226.87     19.79   260.00     88.00%
2259 requests in 10.00s, 1.78MB read
Requests/sec:    225.85
Transfer/sec:    182.23KB
```


**Results: 1 thread, 100 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   321.08ms  234.25ms   1.79s    66.12%
  Req/Sec   328.79     58.77   450.00     75.00%
3275 requests in 10.01s, 2.57MB read
Requests/sec:    327.28
Transfer/sec:    263.19KB
```


**Results: 1 thread, 10000 connection, 10 seconds**:


```sh
Thread Stats   Avg      Stdev     Max   +/- Stdev
  Latency   302.01ms  231.19ms   1.92s    71.12%
  Req/Sec   328.97     49.46   420.00     75.76%
3245 requests in 10.04s, 2.55MB read
Socket errors: connect 8980, read 0, write 0, timeout 0
Requests/sec:    323.34
Transfer/sec:    260.51KB
```


#### mongomatic

=> seems too old (mongoid is working fine for mongo-db)


#### ripple


TBD (haven't a 64 bit system)


#### dynamoid


TBD (don't have a private aws account)



#### Datamapper

=> is broken


## Inspiration

<https://github.com/allcentury/ruby-framework-benchmarks.git>
