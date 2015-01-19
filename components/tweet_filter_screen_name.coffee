noflo = require 'noflo'

class tweet_filter_screen_name extends noflo.Component
  description: 'The tweet_filter_screen_name component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'filter'

  constructor: ->
    @screen_name = null
    @data_url = null

    @inPorts = new noflo.InPorts
      screen_name:
        datatype: 'string'
        description: 'screen_name for filter'
      in:
        datatype: 'string'
        description: 'data for filter'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by user id'

    @inPorts.screen_name.on 'data', (@screen_name) =>
    @inPorts.in.on 'data', (@data_url) =>
      return unless @screen_name
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?screen_name_filter=true&data="+@data_url+"&screen_name="+@screen_name, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null
    
    @inPorts.in.on 'disconnect', (data) =>
      @data_url = null
      @screen_name = null
	
 
exports.getComponent = ->
  new tweet_filter_screen_name()