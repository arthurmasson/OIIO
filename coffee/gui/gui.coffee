class GUI
	constructor: () ->
		oiioSymbols = jsyaml.load(lib)
		loadLibrary($("#library > ul.oiio-list"), oiioSymbols)
		setupLibraryEditor()
		
		$(".ui-draggable").draggable( helper: "clone" )
		$(".ui-droppable").droppable( drop: @dropOIIO )

		toolbarJ = $("#toolbar")
		exports.alertContainerJ = toolbarJ
		saveBtnJ = toolbarJ.find("#save-btn")
		saveBtnJ.click(@sendConnections)

	sendConnections = ()->
		oiioConnections = new Object()
		for oiio in exports.oiios
			oiioConnections[oiio.name] = new Object()
			for outputName, outputs of oiio.outputConnections
				inputName = ""
				for output, i in outputs
					if i==0
						inputName = output.startConnectorJ.attr("data-name")
						oiioConnections[oiio.name][inputName] = new Array()
					connection = new Object()
					connection.inIndex = output.startConnectorJ.index()
					connection.outIndex = output.endConnectorJ.index()
					connection.oiio = output.OIIOout.name
					connection.name = output.endConnectorJ.attr("data-name")
					connection.type = output.startConnectorJ.attr("data-type")
					oiioConnections[oiio.name][inputName].push(connection)
		# console.log oiioConnections
		# console.log JSON.stringify(oiioConnections, null, '\t')
		socket.send(JSON.stringify(oiioConnections))

	makeUniqueName = (oiioName)->
		if exports.oiioNames.hasOwnProperty(oiioName)
			exports.oiioNames[oiioName]++
		else
			exports.oiioNames[oiioName] = 0
		return oiioName + "_" + exports.oiioNames[oiioName]


	dropOIIO = (ev,ui) ->
		if !ui.draggable.hasClass("oiio-symbol")
			return
		oiioSymbolJ = ui.draggable
		oiioContainerJ = $(ev.target)
		name = @makeUniqueName(oiioSymbolJ.text())
		exports.oiios.push(new GUI_OIIO(oiioSymbols.oiios[oiioSymbolJ.html()], oiioContainerJ, name, ui.offset))