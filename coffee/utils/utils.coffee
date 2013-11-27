# display an alert with message, type and delay in container (or in alert div by default)
add_alert = (message, type="", delay=2000, container=null) ->
	if type != "" then type = " alert-" + type

	alert = $("""
		<div class="#{type} alert fade in" data-brain-id="#{exports.nAlerts}">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<p>#{message}</p>
		</div>
	""")
	exports.nAlerts++

	if container?
		container.after(alert)
	else
		exports.alertContainerJ.append(alert)

	if delay!=0
		alert.delay(delay).fadeOut(2500, ()->$(this).remove())

	return exports.nAlerts-1

removeFromArray = (element, array)->
	index = array.indexOf(element)
	if index > -1
		array.splice(index, 1)

getType = (obj) ->
	return Object.prototype.toString.call(obj)

getParentTextOnly = (objJ) ->
	return objJ.clone().children().remove().end().text()

removeLastChunk = (string) ->
	uIdx = string.lastIndexOf("_")
	return if uIdx<0  then string else string.slice(0, uIdx)

# look for children of 'parentJ' which have the name 'name', and make a new name = 'name' + separator + n, n being the lowest unexisting number used as 'name' suffix
# the new name must be set to data-name on the newly created element
makeNewName = (parentJ, name, separator="_")->
	if parentJ.find("[data-name='" + name + "']").size()>0
		n = 1
		while parentJ.find("[data-name='" + name + separator + n + "']").size()>0
			n++
		return name + separator + n
	else
		return name
