###########################################################################
## Copyright (C) 2014  Jason E. Aten                                     ##
##  rmq is licensed under the Apache 2.0. license.
##  http://www.apache.org/licenses/
###########################################################################

srv <- function(x) {
    .Call("Srv", x, PACKAGE="rmq")
}

cli <- function(x) {
    .Call("Cli", x, PACKAGE="rmq")
}

callcount <- function() {
    .Call("Callcount", PACKAGE="rmq")
}

listenAndServe <- function(addr, handler) {
  invisible(.Call("ListenAndServe", addr, handler, new.env()))
}

to.msgpack <- function(x) {
  .Call("ToMsgpack", x)
}

from.msgpack <- function(x) {
  .Call("FromMsgpack", x)
}
