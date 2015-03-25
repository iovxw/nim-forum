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

import jester, asyncdispatch, htmlgen

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
                  a(href="#", class="btn btn-primary", "注册"),
                  a(href="#", class="btn btn-success", "登录")
                )
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

runForever()