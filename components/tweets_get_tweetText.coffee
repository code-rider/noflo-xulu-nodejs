noflo = require 'noflo'

class tweets_get_tweetText extends noflo.Component
  description: 'The tweets_get_tweetText component receives a path string in the in port,
    if this component palced at very first number in graph then receives newly created project or graph directory path 
	if not then it receives last components created processed data file path '
  icon: 'envelope'

  constructor: ->
    @data_url = null
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: ''
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'tweet text file path'

    @inPorts.in.on 'data', (@data_url) =>
      req = new XMLHttpRequest
      req.open 'GET', "http://54.165.223.89:1337/?get_tweetText=true&data="+@data_url, true
      req.onreadystatechange = =>
        if req.readyState is 4
          if req.status is 200
            text_line = req.responseText.split "\n"
            for tweet in text_line
              tweetObj = JSON.parse tweet
              @outPorts.out.send tweetObj.text
            @outPorts.out.disconnect()
      req.send null

exports.getComponent = ->
  new tweets_get_tweetText()