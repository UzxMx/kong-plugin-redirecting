package = "kong-plugin-redirecting"
version = "0.1-1"
supported_platforms = {"linux", "macosx"}
source = {
  url = "git://github.com/uzxmx/kong-plugin-redirecting",
  tag = "v0.1-1"
}
description = {
  summary = "A plugin that redirects to a configured host",
  license = "Apache 2.0",
  homepage = "https://github.com/uzxmx/kong-plugin-redirecting",
  detailed = [[
      A plugin that redirects to a configured host.
  ]],
}
dependencies = {
  "lua ~> 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.redirecting.handler"] = "src/handler.lua",
    ["kong.plugins.redirecting.schema"] = "src/schema.lua"
  }
}
