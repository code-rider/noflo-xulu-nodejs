noflo = require 'noflo'

class tweet_filter_location extends noflo.Component
  description: 'The tweet_filter_location component should filter data by user location'
  icon: 'filter'

  constructor: ->
    @localtion = null
    @data_url = null

    @inPorts = new noflo.InPorts
      localtion:
        datatype: 'string'
        description: 'location for filter'
      in:
        datatype: 'string'
        description: 'data for filter'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by location'

    @inPorts.localtion.on 'data', (@localtion) =>
    @inPorts.in.on 'data', (@data_url) =>
      return unless @localtion
      @outPorts.out.connect()
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?location_filter=true&data="+@data_url+"&localtion="+@localtion, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null
    
    @inPorts.in.on 'disconnect', (data) =>
      @data_url = null
      @localtion = null
	
 
exports.getComponent = ->
  new tweet_filter_location()