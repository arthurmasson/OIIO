#code based on example code from libwebsockets http://git.warmcat.com/cgi-bin/cgit/libwebsockets/

setupSocket = ()->

  if BrowserDetect.browser == "Firefox"
    socket = new MozWebSocket(get_appropriate_ws_url())
  else
    socket = new WebSocket(get_appropriate_ws_url())
  
  try
    socket.onopen = ()->
      add_alert("websocket connection opened!", "success")

    socket.onmessage = (msg)->
      add_alert("message recieved: " + msg.data)

    socket.onclose = ()->
      add_alert("websocket connection closed.", "warning")

  catch exception
    add_alert("Error: " + exception, "error", 0)

# BrowserDetect came from http://www.quirksmode.org/js/detect.html 
# for newer Netscapes (6+)
# for older Netscapes (4-)
get_appropriate_ws_url = ->
  pcol = undefined
  u = document.URL
  
  #
  #	 * We open the websocket encrypted if this page came on an
  #	 * https:// url itself, otherwise unencrypted
  #	 
  if u.substring(0, 5) is "https"
    pcol = "wss://"
    u = u.substr(8)
  else
    pcol = "ws://"
    u = u.substr(7)  if u.substring(0, 4) is "http"
  u = u.split("/")
  pcol + u[0]
BrowserDetect =
  init: ->
    @browser = @searchString(@dataBrowser) or "An unknown browser"
    @version = @searchVersion(navigator.userAgent) or @searchVersion(navigator.appVersion) or "an unknown version"
    @OS = @searchString(@dataOS) or "an unknown OS"

  searchString: (data) ->
    i = 0

    while i < data.length
      dataString = data[i].string
      dataProp = data[i].prop
      @versionSearchString = data[i].versionSearch or data[i].identity
      if dataString
        return data[i].identity  unless dataString.indexOf(data[i].subString) is -1
      else return data[i].identity  if dataProp
      i++

  searchVersion: (dataString) ->
    index = dataString.indexOf(@versionSearchString)
    return  if index is -1
    parseFloat dataString.substring(index + @versionSearchString.length + 1)

  dataBrowser: [
    string: navigator.userAgent
    subString: "Chrome"
    identity: "Chrome"
  ,
    string: navigator.userAgent
    subString: "OmniWeb"
    versionSearch: "OmniWeb/"
    identity: "OmniWeb"
  ,
    string: navigator.vendor
    subString: "Apple"
    identity: "Safari"
    versionSearch: "Version"
  ,
    prop: window.opera
    identity: "Opera"
    versionSearch: "Version"
  ,
    string: navigator.vendor
    subString: "iCab"
    identity: "iCab"
  ,
    string: navigator.vendor
    subString: "KDE"
    identity: "Konqueror"
  ,
    string: navigator.userAgent
    subString: "Firefox"
    identity: "Firefox"
  ,
    string: navigator.vendor
    subString: "Camino"
    identity: "Camino"
  ,
    string: navigator.userAgent
    subString: "Netscape"
    identity: "Netscape"
  ,
    string: navigator.userAgent
    subString: "MSIE"
    identity: "Explorer"
    versionSearch: "MSIE"
  ,
    string: navigator.userAgent
    subString: "Gecko"
    identity: "Mozilla"
    versionSearch: "rv"
  ,
    string: navigator.userAgent
    subString: "Mozilla"
    identity: "Netscape"
    versionSearch: "Mozilla"
  ]
  dataOS: [
    string: navigator.platform
    subString: "Win"
    identity: "Windows"
  ,
    string: navigator.platform
    subString: "Mac"
    identity: "Mac"
  ,
    string: navigator.userAgent
    subString: "iPhone"
    identity: "iPhone/iPod"
  ,
    string: navigator.platform
    subString: "Linux"
    identity: "Linux"
  ]

BrowserDetect.init()
pos = 0