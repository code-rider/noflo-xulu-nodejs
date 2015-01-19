noflo = require 'noflo'

class start extends noflo.Component
  description: 'The start component receives any string in the in port,
    and send request to the server,
	server create a project director for this project and send back project directory path 
	start component send project directory path to out port'
  "icon": "cogs"

  constructor: ->
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: ''
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'empty project direcory path'

    @inPorts.in.on 'data', (data) =>
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?start=start", true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null

exports.getComponent = ->
  new start()