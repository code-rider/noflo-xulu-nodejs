noflo = require 'noflo'

class tweets_filter_followers extends noflo.Component
  description: 'The tweets_filter_followers component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'filter'

  constructor: ->
    @maximum = 0
    @minimum = 0
    @data_url = null

    @inPorts = new noflo.InPorts
      maximum:
        datatype: 'int'
        description: 'maximum number of followers count to filter'
      minimum:
        datatype: 'int'
        description: 'minimun number of followers count o filter'
        default: 0
      in:
        datatype: 'string'
        description: 'data for filter'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by followers_count'

    @inPorts.maximum.on 'data', (@maximum) =>
    @inPorts.minimum.on 'data', (@minimum) =>
    @inPorts.in.on 'data', (@data_url) =>
      return unless @maximum
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?followers=true&data="+@data_url+"&maximum="+@maximum+"&minimum="+@minimum, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null
    
    @inPorts.in.on 'disconnect', (data) =>
      @data_url = null
      @maximum = 0
      @minimum = 0
	
 
exports.getComponent = ->
  new tweets_filter_followers()