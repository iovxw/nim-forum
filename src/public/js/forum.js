function addClass(e, c) {
	if (e.className.indexOf(c) === -1) {
		e.className = e.className + " " + c
	}
}

function delClass(e, c) {
	if (e.className.indexOf(c) != -1) {
		e.className = e.className.replace(" " + c, "")
	}
}

function c() {
	var space = /\s/g
	var title = document.getElementById("ttitle").value.replace(space, "").length
	var body = document.getElementById("tbody").value.replace(space, "").length
	var tag = document.getElementById("ttag").value.replace(space, "").length

	var pubBtn = document.getElementById("publish")
	var preBtn = document.getElementById("preview")

	if (title > 5 && tag > 0) {
		delClass(pubBtn, "disabled")
	}else{
		addClass(pubBtn, "disabled")
	}

	if (body > 0) {
		delClass(preBtn, "disabled")
	}else{
		addClass(preBtn, "disabled")
	}
}