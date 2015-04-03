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

	if (title >= 5 && tag > 0) {
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

function publish() {
	var pubBtn = document.getElementById("publish")
	addClass(pubBtn, "disabled")
	pubBtn.text = "发布中……"

	var title = document.getElementById("ttitle").value
	var body = document.getElementById("tbody").value
	var tag = document.getElementById("ttag").value
	var data = JSON.stringify({
		title: title,
		body: body,
		tag: tag
	})

	var http = new XMLHttpRequest()
	http.open("POST", "/new", true)
	http.onreadystatechange = function() {
		if (http.readyState === 4) {
			if (http.status === 200) {
				alert("发布成功")
				window.location.href = "/"
			} else {
				delClass(pubBtn, "disabled")
				pubBtn.text = "发布失败"
				setTimeout('document.getElementById("publish").text = "发布"', 2000)
			}
		}
	}
	http.send(data)
}

function preview(){
	var preBtn = document.getElementById("preview")
	addClass(preBtn, "disabled")
	preBtn.text = "生成预览中……"

	var http = new XMLHttpRequest()
	http.open("POST", "/preview", true)
	http.onreadystatechange = function() {
		if (http.readyState === 4) {
			if (http.status === 200) {
				//...
			} else {
				delClass(preBtn, "disabled")
				preBtn.text = "预览失败"
				setTimeout('document.getElementById("preview").text = "预览"', 2000)
			}
		}
	}
	http.send(document.getElementById("tbody").value)
}