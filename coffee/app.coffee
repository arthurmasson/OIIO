# --- TOOD --- #
# * check public methods

# --- global variables --- #

exports = new Object()
exports.oiios = new Array()
exports.currentConnection = null
exports.connectorID = 0
exports.alertContainerJ = null
exports.nAlerts = 0
exports.oiioNames = new Object()
exports.templates = null

# ---- tabs ---- #

exports.tabHeader = null
exports.tabCounter = 2
exports.tabs = null

socket = null


$(document).ready(->
	"use strict"

	exports.alertContainerJ = $("#alerts")

	exports.templates = $("#templates")

	exports.tabHeader = exports.templates.find("#tab-header > li")

	exports.tabCounter = 2
	exports.tabs = $(".tabs").tabs()

	exports.tabs.delegate("span.ui-icon-close", "click", closeTab)
	exports.tabs.bind("keyup", onTabKey)
	
	$("#file-manager li").click((ev)->
		addTab($(ev.target).attr("data-type"))
	)


	exports.tabs.find( ".ui-tabs-nav" ).sortable({ connectWith: '.ui-tabs-nav',	receive: transferTab })

	# gui = new GUI()

	# setupSocket()
)

# actual addTab function: adds new tab using the input from the form above
addTab = (type)->
	tabContentHtml = exports.templates.find("[data-type='"+type+"']").clone()
	label = makeNewName($(".tabs > ul.ui-droppable-tab"), type)
	id = "tab-" + exports.tabCounter
	tabContentHtml.attr("id",id)
	li = exports.tabHeader.clone()
	li.find("a").attr("data-name",label).text(label).attr("href", "#" + id).resize(()->
		console.log $(this).innerWidth()
	)
	tabs1 = exports.tabs.filter(".group-1")
	tabs1.find(".ui-tabs-nav").append(li)
	tabs1.append(tabContentHtml)
	tabs1.tabs("refresh")
	exports.tabCounter++


	if type == "Library"
		console.log "Library"
	else if type == "GUI"
		console.log "GUI"
	else if type == "Output"
		if not exports.output?
			exports.output = new Output(tabContentHtml)
	else if type == "OIIO"
		console.log "OIIO"

# transfer the tab to other tabs
transferTab = (event, ui)->
	receiver = $(this).parent()
	sender = $(ui.sender[0]).parent()
	tab = ui.item[0]
	tabJ = $(ui.item[0])

	# Find the id of the associated panel
	panelId = tabJ.attr( "aria-controls" )
	
	tabJ = $(tabJ.removeAttr($.makeArray(tab.attributes).map((item)-> return item.name).join(' ')).remove())
	tabJ.find('a').removeAttr('id tabindex role class')

	$(this).append(tabJ)

	$($( "#" + panelId ).remove()).appendTo(receiver)
	exports.tabs.tabs('refresh')

# close icon: removing the tab on click
closeTab = () ->
	panelId = $(this).closest("li").remove().attr("aria-controls")
	$("#" + panelId).remove()
	exports.tabs.tabs("refresh")

onTabKey = (event) ->
	if event.altKey and event.keyCode is $.ui.keyCode.BACKSPACE
		closeTab()

