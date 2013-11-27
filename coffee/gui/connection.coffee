class Connection
	constructor: (@OIIOin, @OIIOout, @startConnectorJ, @endConnectorJ) ->
		@path = null
		@createPath()

	createPath:()->
		if @path != null
			return
		@path = document.createElementNS("http://www.w3.org/2000/svg","path")
		@path.setAttributeNS(null, "fill", "none")
		@path.setAttributeNS(null, "stroke", "black")
		
		@update()
		
		document.getElementById("svg-connections").appendChild(@path)


	finish:(@startConnectorJ, @endConnectorJ, newOIIOin, newOIIOout)->

		if @OIIOout == null
			@OIIOout = newOIIOout
		else if @OIIOin == null
			@OIIOin = newOIIOin

		if not @OIIOin.outputConnections[@startConnectorJ.attr("id")]?
			@OIIOin.outputConnections[@startConnectorJ.attr("id")] = new Array()

		if @OIIOout.inputConnections[@endConnectorJ.attr("id")]?
			@OIIOout.inputConnections[@endConnectorJ.attr("id")].remove()

		@OIIOin.outputConnections[@startConnectorJ.attr("id")].push(@)
		@OIIOout.inputConnections[@endConnectorJ.attr("id")] = @

		@startConnectorJ.addClass("connected")
		@endConnectorJ.addClass("connected")

		@createPath()
		@update()
		sendConnections()

	update:(uiPosition) ->

		startPos = new Object()
		endPos = new Object()

		if @startConnectorJ?
			startPos.top = @startConnectorJ.offset().top + @startConnectorJ.height()*0.5
			startPos.left = @startConnectorJ.offset().left + @startConnectorJ.width()
		else
			startPos = uiPosition

		if @endConnectorJ?
			endPos.top = @endConnectorJ.offset().top + @endConnectorJ.height()*0.5
			endPos.left = @endConnectorJ.offset().left
		else
			endPos = uiPosition

		# outToIn = @startConnectorJ? && @startConnectorJ.parent().hasClass("outputs")

		@updatePath(startPos, endPos)

	updatePath:(startPos, endPos) ->

		if not startPos?
			startPos = endPos
		if not endPos?
			endPos = startPos

		offset = $("#svg-connections").offset()

		startX = startPos.left - offset.left
		startY = startPos.top - offset.top

		endX = endPos.left - offset.left
		endY = endPos.top - offset.top

		midX = startX+(endX-startX)/2

		if endX > startX
			@path.setAttributeNS(null, "d", 'M'+startX+','+startY+'C'+midX+','+startY+','+midX+','+endY+','+endX+','+endY+'')
		else
			offsetX = 0.5*Math.abs(endY-startY)
			midY = startY+(endY-startY)/2
			# if outToIn
			start2X = startX + offsetX
			end2X = endX - offsetX
			# else
			# 	start2X = startX - offsetX
			# 	end2X = endX + offsetX
			@path.setAttributeNS(null, "d", 'M'+startX+','+startY+'C'+start2X+','+startY+','+start2X+','+midY+','+startX+','+midY+'L'+endX+','+midY+'C'+end2X+','+midY+','+end2X+','+endY+','+endX+','+endY)

	removeIfUnfinished:() ->
		if @OIIOin == null or @OIIOout == null # not finished, not dropped: hide
			@remove()
			exports.currentConnection = null

	remove:() ->
		if @OIIOin != null && @OIIOin.outputConnections[@startConnectorJ.attr("id")]?
			removeFromArray(@,@OIIOin.outputConnections[@startConnectorJ.attr("id")])
		if @OIIOout != null && @OIIOout.inputConnections[@endConnectorJ.attr("id")] == this
			@OIIOout.inputConnections[@endConnectorJ.attr("id")] = null
		
		$(@path).remove()
		sendConnections()
		
		@path = null
		
		@OIIOin = null
		@OIIOout = null