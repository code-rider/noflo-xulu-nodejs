noflo = require 'noflo'

class tweet_filter_date extends noflo.Component
  description: 'The tweet_filter_date component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'filter'

  constructor: ->
    @start_date = null
    @end_date = null
    @data_url = null

    @inPorts = new noflo.InPorts
      start_date:
        datatype: 'date'
        description: 'maximum date value to filter'
      end_date:
        datatype: 'date'
        description: 'minimun date value to filter'
      in:
        datatype: 'string'
        description: 'data for filter'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by tweet created date'

    @inPorts.start_date.on 'data', (@start_date) =>
    @inPorts.end_date.on 'data', (@end_date) =>
    @inPorts.in.on 'data', (@data_url) =>
      return unless @start_date and @end_date
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?tweet_created_filter=true&data="+@data_url+"&start_date="+@start_date.getTime()+"&end_date="+@end_date.getTime(), true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null
    
    @inPorts.in.on 'disconnect', (data) =>
      @data_url = null
      @start_date = null
      @end_date = null
	
 
exports.getComponent = ->
  new tweet_filter_date()