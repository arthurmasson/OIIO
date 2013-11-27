loadLibrary = (libraryJ, oiioSymbols)->
	for oiioName, oiio of oiioSymbols.oiios
		itemJ = $('<li  class="oiio-symbol ui-draggable"></li>')
		itemJ.html(oiioName)
		libraryJ.append(itemJ)

setupLibraryEditor = ()->
	libraryEditor = ace.edit("library-editor")
	libraryEditor.setValue(lib)
	libraryEditor.setTheme("ace/theme/monokai");
	libraryEditor.getSession().setMode("ace/mode/yaml")
	document.getElementById('library-editor').style.fontSize = '14px'
