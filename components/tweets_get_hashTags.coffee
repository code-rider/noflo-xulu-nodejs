noflo = require 'noflo'

class tweets_get_hashTags extends noflo.Component
  description: 'The tweets_get_hashTags component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'tags'

  constructor: ->
    @data_url = null
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: ''
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'hash tags file path'

    @inPorts.in.on 'data', (@data_url) =>
      req = new XMLHttpRequest
      req.open 'GET', "http://192.168.1.59:1337/?get_hashTags=true&data="+@data_url, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            hashtags = req.responseText.split "\n"
            unique_tags = hashtags.unique()
            for hashtag in unique_tags
              @outPorts.out.send hashtag
            @outPorts.out.disconnect()
      req.send null

  Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

exports.getComponent = ->
  new tweets_get_hashTags()