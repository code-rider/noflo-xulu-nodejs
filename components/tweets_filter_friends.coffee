noflo = require 'noflo'

class tweets_filter_friends extends noflo.Component
  description: 'The tweets_filter_friends component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project/graph empty directory path 
	if not then it receives last components created processed data file path '
  icon: 'filter'

  constructor: ->
    @maximum = 0
    @minimum = 0
    @data_url = null

    @inPorts = new noflo.InPorts
      maximum:
        datatype: 'int'
        description: 'maximum number of friends count to filter'
      minimum:
        datatype: 'int'
        description: 'minimun number of friends count o filter'
        default: 0
      in:
        datatype: 'string'
        description: 'data for filter'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by friends_count'

    @inPorts.maximum.on 'data', (@maximum) =>
    @inPorts.minimum.on 'data', (@minimum) =>
    @inPorts.in.on 'data', (@data_url) =>
      return unless @maximum and @data_url
      req = new XMLHttpRequest
      req.open 'GET', "http://192.168.1.59:1337/?friends=true&data="+@data_url+"&maximum="+@maximum+"&minimum="+@minimum, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null

    @inPorts.in.on 'disconnect', (data) =>
      @maximum = 0
      @minimum = 0
      @data_url = null
	
 
exports.getComponent = ->
  new tweets_filter_friends()