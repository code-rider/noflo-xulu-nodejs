noflo = require 'noflo'

class tweet_filter_hashTags extends noflo.Component
  description: 'The tweet_filter_hashTags component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'filter'

  constructor: ->
    @hashTags = null
    @data_url = null

    @inPorts = new noflo.InPorts
      hash_tag:
        datatype: 'string'
        description: 'hash_tag for filter'
      in:
        datatype: 'string'
        description: 'data for filter'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by hash_tag'

    @inPorts.hash_tag.on 'data', (@hashTags) =>
    @inPorts.in.on 'data', (@data_url) =>
      return unless @hashTags
      req = new XMLHttpRequest
      req.open 'GET', "http://192.168.1.59:1337/?hash_tag_filter=true&data="+@data_url+"&hashTags="+@hashTags, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            @outPorts.out.send req.responseText
            @outPorts.out.disconnect()
      req.send null
    
    @inPorts.in.on 'disconnect', (data) =>
      @data_url = null
      @hashTags = null
	
 
exports.getComponent = ->
  new tweet_filter_hashTags()