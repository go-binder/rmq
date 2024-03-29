# rmq: R Messaging and Queuing

### Or: How to utilize Go libraries from R.

The much anticipated Go 1.5 release brought strong support for building C-style shared libraries (.so files) from Go source code and libraries. 

*This is huge*. It opens up many exciting new possibilities. In this proof-of-concept project (rmq), we explore using this new capability to extend R with Go libraries.

Package rmq provides messaging based on msgpack and websockets. It demonstrates calling from R into Golang (Go) libraries to extend R with functionality available in Go.

 We use the Go library https://github.com/ugorji/go codec for msgpack encoding and decoding. This is a high performance implementation. We use it in a mode where it only supports the updated msgpack 2 (current) spec.

For websockets, we use the terrific https://github.com/gorilla/websocket library. As time permits in the future, we'll extend this proof of concept into a more integrated messaging system.

##Status

Proof of concept. A weekend sprint worth of work was done. The msgpack portion is solid and tested. The websocket portion is there, but is just a proof of concept without much polish (yet). Integration between the two is still todo.

## example R session, showing the msgpack library at work

~~~
> library(rmq)
> input = list() # make an R object to serialize.
> input$Blob = as.raw(c(0xff,0xf0,0x06))
> input$D = c("hello","world")
> input$E = c(32, 17)
> o=to.msgpack(input)
> o # look at the raw bytes in msgpack format
 [1] 83 a4 42 6c 6f 62 c4 03 ff f0 06 a1 44 92 a5 68 65 6c 6c 6f a5 77 6f 72 6c
[26] 64 a1 45 92 cb 40 40 00 00 00 00 00 00 cb 40 31 00 00 00 00 00 00
> from.msgpack(o) # now the inverse
$Blob
[1] ff f0 06

$D
[1] "hello" "world"

$E
[1] 32 17

> 
~~~

Copyright 2015 Jason E. Aten, Ph.D.

License: Apache 2.0 for the top level RMQ code and integration. Individual vendored library components include their own licenses which are Apache2, MIT, or BSD style. See the src/vendor subdirectories for details.

Requires: Go 1.5.1 for GO15VENDOREXPERIMENT=1
