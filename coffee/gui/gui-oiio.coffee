class GUI_OIIO
	constructor: (oiioDesc, oiioContainerJ, @name, uiOffset) ->
		@inputConnections = new Object()
		@outputConnections = new Object()

		@oiioJ = $("""
			<div class="oiio ui-draggable clearfix">
				<div class="head"> """ + @name + """</div>
			</div>
		""")
		
		connectorContainerJ = $('<div class="connectors"></div>')

		for connectorsName, connectors of oiioDesc
			connectorsJ = $('<ul class="' + connectorsName + '"></ul>')
			connectorType = connectorsName.replace("extendable_","")
			connectorsJ.addClass(connectorType)
			isExtandable = connectorsName.indexOf("extendable") >= 0
			for connector in connectors
				@createConnector(connector, isExtandable, connectorType, connectorsJ)
			if isExtandable
				connectorsJ.append('<button class="btn add">+</button>')
			connectorContainerJ.append(connectorsJ)
			

		@oiioJ.append(connectorContainerJ)

		top = uiOffset.top
		left = uiOffset.left

		@oiioJ.draggable(drag: @updateConnections, stop: @updateConnections)
		@oiioJ.find("button.add").click(@addConnector)
		oiioContainerJ.append(@oiioJ)

		@oiioJ.offset(top:top,left:left)

	createConnector:(connector, isExtandable, connectorType, connectorsJ) ->
		connectorJ = $('<li class="ui-draggable ui-droppable"></li>')
		connectorJ.attr("data-value", connector.default)
		connectorJ.attr("data-type", connector.type)
		connectorJ.attr("id", "connector_"+exports.connectorID)
		exports.connectorID++
		
		connector.name = makeNewName(connectorsJ, connector.name)

		connectorJ.text(connector.name)
		connectorJ.attr("data-name", connector.name)
		if isExtandable
			deleteBtnJ = $('<button type="button" class="close">&times;</button>')
			if connectorType == "inputs"
				connectorJ.append(deleteBtnJ)
			else if connectorType == "outputs"
				connectorJ.prepend(deleteBtnJ)
			deleteBtnJ.click(@deleteConnector)
		if connectorsJ.children().last().is("button")
			connectorJ.insertBefore(connectorsJ.children().last())
		else
			connectorsJ.append(connectorJ)
		connectorJ.draggable( helper:"clone" , start: @startConnection, drag: @updateConnection, stop: @stopConnection ).droppable( drop: @dropConnection, tolerance: "pointer" )
		return connectorJ

	addConnector:(ev) =>
		connector = new Object()
		btnJ = $(ev.target)
		prevConnectorJ = btnJ.prev()
		connectorsJ = btnJ.parent()
		connector.default = prevConnectorJ.attr("data-value")
		connector.type = prevConnectorJ.attr("data-type")
		connector.name = removeLastChunk(prevConnectorJ.attr("data-name"))
		isExtandable = connectorsJ.hasClass("extendable_outputs") || connectorsJ.hasClass("extendable_inputs")
		connectorType = if connectorsJ.hasClass("outputs") then "outputs" else "inputs"
		connectorJ = @createConnector(connector, isExtandable, connectorType, connectorsJ)
		height = connectorJ.outerHeight()
		@oiioJ.nextAll().offset((index, currentOffset)-> return { top: currentOffset.top-height, left: currentOffset.left } )
		@updateConnections()

	deleteConnector:(ev) =>
		btnJ = $(ev.target)
		connectorJ = btnJ.parent()
		connectorsJ = connectorJ.parent()
		if connectorsJ.find("li").size() <= 1
			return
		if connectorsJ.hasClass("outputs") && @outputConnections[connectorJ.attr("id")]?
			@outputConnections[connectorJ.attr("id")].remove()
		else if connectorsJ.hasClass("inputs") && @inputConnections[connectorJ.attr("id")]?
			@inputConnections[connectorJ.attr("id")].remove()
		height = connectorJ.outerHeight()
		connectorJ.remove()
		@oiioJ.nextAll().offset((index, currentOffset)-> return { top: currentOffset.top+height, left: currentOffset.left } )
		@updateConnections()

	# Callbacks for the creation of a connection: exports.currentConnection
	startConnection:(ev,ui) =>
		if $(ev.target).parent().hasClass("outputs")
			exports.currentConnection = new Connection(this, null, $(ev.target), null)
		else if $(ev.target).parent().hasClass("inputs")
			exports.currentConnection = new Connection(null, this, null, $(ev.target))

	updateConnection:(ev,ui) =>
		exports.currentConnection.update(ui.offset)

	stopConnection:(ev,ui) =>
		exports.currentConnection?.removeIfUnfinished()

	dropConnection:(ev,ui) =>
		if $(ev.target).parent().hasClass("inputs") && exports.currentConnection.OIIOin?
			exports.currentConnection.finish(ui.draggable, $(ev.target), null, this)
		else if $(ev.target).parent().hasClass("outputs") && exports.currentConnection.OIIOout?
			exports.currentConnection.finish($(ev.target), ui.draggable, this, null)
		else
			exports.currentConnection.remove()
		exports.currentConnection = null

	# Callbacks to update all connections when dragging
	updateConnections:(ev,ui) =>
		for connectorName, connection of @inputConnections
			connection?.update()
		for connectorName, connections of @outputConnections
			for connection in connections
				connection?.update()





