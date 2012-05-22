# This implements the SockJS network API for ShareJS.
sockjs = require 'sockjs'

sessionHandler = require('./session').handler

wrapSession = (conn) ->
  conn.abort = -> @close()
  conn.stop = -> @end()
  conn.send = (response) -> @write JSON.stringify(response)
  conn.ready = -> @readyState is 1
  conn.on 'data', (data) -> @emit 'message', JSON.parse(data) 
  conn


exports.attach = (server, createAgent, options) ->
  sjsServer = sockjs.createServer options
  sjsServer.on 'connection', (conn) ->  sessionHandler wrapSession(conn), createAgent
  sjsServer.installHandlers server, {prefix: "/sockjs"}