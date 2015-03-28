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

import jester, asyncdispatch, json, md5, times, os, strutils, db_sqlite
from httpclient import get, newAsyncHttpClient, HttpRequestError
import htmlgen

var db = open(connection="forum.db", user="forum",
              password="",  database="forum")

####### 初始化 #######
if not dirExists("session"): createDir("session")
if not fileExists("forum.db"):
  db.exec(sql"""
    create table if not exists topics(
      id       char(8)      not null,
      name     varchar(100) not null,
      views    integer      not null,
      modified timestamp    not null default (DATETIME('now'))
    );""",
  [])


routes:
  get "/":
    resp html(
      lang="cn",
      head(
        link(rel="stylesheet", href="./css/bootstrap.min.css"),
        link(rel="stylesheet", href="./css/forum.css")
      ),
      body(
        `div`(class="navbar navbar-default",
          `div`(class="container",
            `div`(class="navbar-header",
              button(class="navbar-toggle collapsed", `data-toggle`="collapse", `data-target`="#navbar-main",
                span(class="sr-only", "Toggle navigation"),
                span(class="icon-bar"),
                span(class="icon-bar"),
                span(class="icon-bar")
              ),
              a(class="navbar-brand", href="#", "Nim Forum")
            ),
            `div`(class="collapse navbar-collapse", id="navbar-main",
              ul(class="nav navbar-nav navbar-left",
                li(class="active", a(href="#", "Home")),
                li(a(href="#", "Link"))
              ),
              ul(class="nav navbar-form navbar-right",
                `div`(class="btn-group",
                  a(href="#login", class="btn btn-primary", `data-toggle`="modal", "注册"),
                  a(href="#login", class="btn btn-success", `data-toggle`="modal", "登录")
                )
              )
            )
          )
        ),
        `div`(id="login", class="modal fade",
          `div`(class="modal-dialog",
            `div`(class="modal-content",
              `div`(class="modal-header",
                button(class="close", `data-dismiss`="modal", `aria-hidden`="true", "x"),
                h4(class="modal-title", "登录")
              ),
              `div`(class="modal-body",
                a(
                  href="https://github.com/login/oauth/authorize?client_id=7e34977a09b773585ca7&scope=user:email",
                  class="github-button",
                  img(alt="Github", src="./images/GitHub-Mark.png")
                )
              ),
              `div`(class="modal-footer",
                button(class="btn btn-block btn-danger", `data-dismiss`="modal", "取消")
              )
            )
          )
        ),
        `div`(class="container",
          a(href="http://nim-lang.org", "Hello World!")
        ),
        script(`type`="text/javascript", src="./js/forum.js"),
        script(`type`="text/javascript", src="//cdn.bootcss.com/jquery/1.11.2/jquery.min.js"),
        script(`type`="text/javascript", src="//cdn.bootcss.com/bootstrap/3.3.4/js/bootstrap.min.js")
      )
    )
  get "/oauth/github":
    var
      code = @"code"
      clientID = "7e34977a09b773585ca7"
      clientSecret = "321dd84072a92ab6bb988cb9bcfa88d4f9675c10"
      url = "https://github.com/login/oauth/access_token" &
        "?client_id=" & clientID &
        "&client_secret=" & clientSecret &
        "&code=" & code

    let token = await(newAsyncHttpClient().get(url)).body
    if token[0..11] != "access_token":
      halt(Http401)

    let
      j = await(newAsyncHttpClient().get(
        "https://api.github.com/user?" & token)).body

      userData = parseJson(j)
      session = token.getMD5()
      id = userData["login"].str
      dir = "session"/session[0..1]
      time = timeInfoToTime(getGMTime(getTime()) +
        initInterval(days=90)).toSeconds()

    resp "hi, " & userData["name"].str

    setCookie("id", id, daysForward(90))
    setCookie("session", session, daysForward(90))

    if not dirExists(dir): createDir(dir)
    writeFile(dir/session, id & " " & formatFloat(time))

    let data = split(readFile(dir/session))
    echo data[0]
    echo parseFloat(data[1])

runForever()