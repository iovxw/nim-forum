#   Copyright 2015 Bluek404 <i@bluek404.net>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import sockets, httpserver, httpclient, threadpool, os, strtabs,
  json, md5, times, strutils, db_sqlite, math, cookies
import htmlgen

const
  clientID = "7e34977a09b773585ca7"
  clientSecret = "7cd0e5b48a320d802025f3517ead795cd48c06f9"

var db = open(connection="forum.db", user="forum",
              password="",  database="forum")

####### 初始化 #######
if not dirExists("session"): createDir("session")
if getFileSize("forum.db") == 0:
  db.exec(sql"""
    create table if not exists topic(
      id       char(8)      not null,
      title    varchar(20)  not null,
      preview  varchar(50)  not null,
      views    integer      not null
    );""")
  db.exec(sql"""
    create table if not exists post(
      topic    char(8)       not null,
      author   varchar(20)   not null,
      content  varchar(1000) not null,
      xx       integer       not null,
      oo       integer       not null,
      type     integer       not null,
      creation timestamp     not null default (DATETIME('now'))
    );""")
  db.exec(sql"""
    create table if not exists tag(
      topic char(8)     not null,
      tag   varchar(20) not null
    );""")
  db.exec(sql"""
    create table if not exists user(
      id          varchar(20)   not null,
      name        varchar(20)   not null,
      avatar      varchar(100)  not null,
      description varchar(1000) not null
    );""")

const 
  http404Page = "HTTP/1.1 404 Not Found\n\n" &
    html(lang="zh",
      body(
        p("404")))

  http401Page = "HTTP/1.1 401 Unauthorized\n\n" &
    html(lang="zh",
      body(
        p("401")))

proc navBar(id: string): string =
  var userBtn: string
  if id == "":
    userBtn = a(href="#login", class="btn btn-primary", `data-toggle`="modal",
                i(class="fa fa-user-plus"), " 注册") &
              a(href="#login", class="btn btn-success", `data-toggle`="modal",
                i(class="fa fa-user"), " 登录")
  else:
    let name = db.getValue(sql"SELECT name FROM user WHERE id=?", id)
    userBtn = a(href="/setting", class="btn btn-primary", `data-toggle`="modal",
                i(class="fa fa-user"), " " & name) &
              a(href="/logout", class="btn btn-success", `data-toggle`="modal",
                i(class="fa fa-power-off"), " 退出")

  return `div`(class="navbar navbar-default",
    `div`(class="container",
      `div`(class="navbar-header",
        button(class="navbar-toggle collapsed", `data-toggle`="collapse", `data-target`="#navbar-main",
          span(class="sr-only", "Toggle navigation"),
          span(class="icon-bar"),
          span(class="icon-bar"),
          span(class="icon-bar")),
        a(class="navbar-brand", href="#", "Nim Forum")),
      `div`(class="collapse navbar-collapse", id="navbar-main",
        ul(class="nav navbar-nav navbar-left",
          li(class="active", a(href="#", "Home")),
          li(a(href="#", "Link"))
        ),
        ul(class="nav navbar-form navbar-right",
          `div`(class="btn-group",
            userBtn)))))

proc loginBox(id: string): string =
  if id == "":
    return `div`(id="login", class="modal fade",
      `div`(class="modal-dialog",
        `div`(class="modal-content",
          `div`(class="modal-header",
            button(class="close", `data-dismiss`="modal", `aria-hidden`="true", "x"),
            h4(class="modal-title", "登录")),
          `div`(class="modal-body",
            a(href="https://github.com/login/oauth/authorize?scope=user:email&client_id=" & clientID,
              class="github-button",
              img(alt="Github", src="./images/GitHub-Mark.png"))),
          `div`(class="modal-footer",
            button(class="btn btn-block btn-danger", `data-dismiss`="modal", "取消")))))
  else:
    return ""

proc pageTmpl(t, b: string): string =
  return html(lang="zh-CN",
    head(
      title(t),
      link(rel="stylesheet", href="./css/font-awesome.min.css"),
      link(rel="stylesheet", href="./css/bootstrap.min.css"),
      link(rel="stylesheet", href="./css/forum.css")),
    body(
      b,
      script(`type`="text/javascript", src="./js/forum.js"),
      script(`type`="text/javascript", src="//cdn.bootcss.com/jquery/1.11.2/jquery.min.js"),
      script(`type`="text/javascript", src="//cdn.bootcss.com/bootstrap/3.3.4/js/bootstrap.min.js")))

proc index(id = ""): string =
  var topics = ""
  for i in 0..50:
    topics.add a(href="#", class="list-group-item",
      h4(class="list-group-item-heading", "一个简洁而又简单的论坛程序"),
      p(class="list-group-item-text", 
        "这里显示帖子内容的预览。为了只关注信息所以不显示发帖人发帖时间发帖人头像最后回复时间等等……"))

  let pagination = ul(class="pager",
    li(class="previous disabled", a("← Newer")),
    li(class="next", a("Older →")))

  let body = navBar(id) &
    loginBox(id) &
    `div`(class="container",
      `div`(class="col-sm-8",
        `div`(class="list-group well well-sm",
          topics)),
      `div`(class="col-sm-4",
        `div`(class="well well-sm",
          `div`(class="panel panel-default",
            `div`(class="panel-body",
              "Panel content")),
          `div`(class="panel panel-primary",
            `div`(class="panel-heading",
              h3(class="panel-title", "Panel primary")),
            `div`(class="panel-body",
              "Panel content")),
          `div`(class="panel panel-success",
            `div`(class="panel-heading",
              h3(class="panel-title", "Panel success")),
            `div`(class="panel-body",
              "Panel content")),
          `div`(class="panel panel-warning",
            `div`(class="panel-heading",
              h3(class="panel-title", "Panel warning")),
            `div`(class="panel-body",
              "Panel content")),
          a(id="new", href="/new", class="btn btn-success btn-block", "创建新主题")),
          `div`(class="well well-sm",
            pagination)))

  return pageTmpl("Nim Forum —— 首页", body)

proc newTopic(id: string): string =
  let body = navBar(id) &
    `div`(class="container",
      `div`(class="col-sm-8",
        `div`(class="list-group well well-sm",
          input(class="form-control", placeholder="标题……"),
          textarea(class="form-control", rows="15", cols="30"),
          input(class="form-control input-sm", placeholder="标签，使用空格分割"),
          `div`(class="btn-group btn-group-justified",
            a(class="btn btn-default btn-sm", "预览"),
            a(class="btn btn-warning btn-sm", "发布")))),
      `div`(class="col-sm-4",
        `div`(class="well well-sm",
          `div`(class="panel panel-primary",
            `div`(class="panel-heading",
              h3(class="panel-title", "发帖提示")),
            `div`(class="panel-body",
              "Panel content")),
          `div`(class="panel panel-success",
            `div`(class="panel-heading",
              h3(class="panel-title", "社区规则")),
            `div`(class="panel-body",
              "Panel content")))))

  return pageTmpl("新主题", body)

proc randomStr(): string =
  # TODO: 更好的随机数
  return getMD5(intToStr(random(1000000)))

proc putSession(id, session: string) =
  # 当前时间再加30天
  let time = int(getTime()) + 30 * (60 * 60 * 24)
  let dir = "session"/session[0..1]
  if not dirExists(dir): createDir(dir)
  writeFile(dir/session, id & " " & intToStr(time))

proc checkSession(id, session: string): bool =
  ## 检查 session 是否有效
  ## 如果有效则返回 true 并删除 session （同一个 session 不使用两次）
  result = false
  if session != "" and id != "":
    let file = "session"/session[0..1]/session

    if fileExists(file):
      let data = split(readFile(file))

      if data[0] == id:
        removeFile(file) # 身份已确认，删除旧 session
        let time = int(getTime())

        # 检查 session 是否过期
        if parseInt(data[1]) >= time:
          result = true

proc daysForward(days: int): TimeInfo =
  var t = Time(int(getTime()) + days * (60 * 60 * 24))
  return t.getGMTime()

proc parseUrlQuery(query: string): StringTableRef =
  result = newStringTable(modeCaseInsensitive)
  let kvs = query.split('&')
  for kv in kvs:
    let buf = kv.split('=')
    if buf.len == 2:
      result[buf[0]] = buf[1]

proc githubOAuth(code: string): string =
  var
    url = "https://github.com/login/oauth/access_token" &
      "?client_id=" & clientID &
      "&client_secret=" & clientSecret &
      "&code=" & code
    j: string

  try:
    j = getContent("https://api.github.com/user?" & getContent(url))
  except:
    result = http401Page
    return

  let
    userData = parseJson(j)
    session = randomStr()
    id = userData["login"].str
    name = userData["name"].str
    avatar = userData["avatar_url"].str

  result = ("HTTP/1.1 200 OK\n" &
            "Content-Type: text/html\n")
  result.add(setCookie("id", id, path="/")&"\n")
  result.add(setCookie("session", session, daysForward(30), path="/")&"\n")
  result.add("\n")

  result.add("hi, " & name)

  putSession(id, session)

  let oldName = db.getValue(sql"SELECT name FROM user WHERE id=?", id)
  if oldName == "":
    # 用户不存在，新建用户
    db.exec(sql"INSERT INTO user VALUES (?, ?, ?, ?)", id, name, avatar, "")
  elif oldName != name:
    # 更新用户昵称
    db.exec(sql"UPDATE user SET name = ? WHERE id = ?", name, id)

proc handleRequest(s: TServer) =
  echo(s.ip, " ", s.reqMethod, " ", s.path)
  block routes:
    case s.path
    of "/":
      s.client.send("HTTP/1.1 200 OK\n" &
                    "Content-Type: text/html\n")
      let
        cookies = parseCookies(s.headers["Cookie"])
        id = cookies["id"]
        session = cookies["session"]

      if checkSession(id, session):
        let newSession = randomStr()
        s.client.send(setCookie("session", newSession, daysForward(30), path="/")&"\n")
        s.client.send("\n")

        s.client.send(index(id))
        putSession(id, newSession)
      else:
        s.client.send("\n")
        s.client.send(index())
    of "/oauth/github":
      let code = parseUrlQuery(s.query)["code"]
      s.client.send(githubOAuth(code))
    of "/logout":
      let
        cookies = parseCookies(s.headers["Cookie"])
        id = cookies["id"]
        session = cookies["session"]

      discard checkSession(id, session)
      s.client.send("HTTP/1.1 302 OK\n" &
                    "Location: /")
    of "/new":
      let
        cookies = parseCookies(s.headers["Cookie"])
        id = cookies["id"]
        session = cookies["session"]

      if checkSession(id, session):
        s.client.send("HTTP/1.1 200 OK\n" &
                      "Content-Type: text/html\n")
        let newSession = randomStr()
        s.client.send(setCookie("session", newSession, daysForward(30), path="/")&"\n")
        s.client.send("\n")

        s.client.send(newTopic(id))
        putSession(id, newSession)
      else:
        s.client.send(http401Page)
    else:
      const staticDir = "public"
      var file: string
      try:
        file = readFile(staticDir/s.path)
        s.client.send("HTTP/1.1 200 OK\n")
        s.client.send("\n")
        s.client.send(file)
      except:
        s.client.send(http404Page)

  s.client.close()

var s: TServer
s.open(Port(5000))
echo("httpserver running on port: ", s.port)
while true:
  s.next()
  spawn handleRequest(s)
s.close()