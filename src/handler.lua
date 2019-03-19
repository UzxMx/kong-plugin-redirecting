local BasePlugin = require "kong.plugins.base_plugin"

local RedirectingHandler = BasePlugin:extend()

function RedirectingHandler:new()
  RedirectingHandler.super.new(self, "redirecting")
end

function RedirectingHandler:access(conf)
  RedirectingHandler.super.access(self)

  if conf.host then
    ngx.redirect(ngx.var.scheme .. '://' .. conf.host .. ngx.var.request_uri, ngx.HTTP_MOVED_PERMANENTLY)
  end
end

return RedirectingHandler
