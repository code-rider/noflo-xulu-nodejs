noflo = require 'noflo'

class tweets_get_screenNames extends noflo.Component
  description: 'The tweets_get_screenNames component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'user'

  constructor: ->
    @data_url = null
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: ''
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'screen names'

    @inPorts.in.on 'data', (@data_url) =>
      @outPorts.out.connect()
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?get_screenNames=true&data="+@data_url, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            screenNames = req.responseText.split "\n"
            unique_names = screenNames.unique()
            for name in unique_names
              @outPorts.out.send name
            @outPorts.out.disconnect()
      req.send null

  Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

exports.getComponent = ->
  new tweets_get_screenNames()