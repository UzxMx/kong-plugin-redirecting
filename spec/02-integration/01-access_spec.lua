local helpers = require "spec.helpers"

describe("without host set", function()
  local proxy_client

  setup(function()
    local bp = helpers.get_db_utils('postgres', nil, { "redirecting" })

    local route = bp.routes:insert({
      hosts = { "example.com" },
    })
    bp.plugins:insert {
      name = "redirecting",
      route = { id = route.id },
      config = {}
    }

    assert(helpers.start_kong({
      database = "postgres",
      plugins = "bundled, redirecting",
      custom_plugins = "redirecting",
      nginx_conf = "spec/fixtures/custom_nginx.template"
    }))

    proxy_client = helpers.proxy_client()
  end)

  it('is not redirected', function()
      local res = proxy_client:get("/", {
        headers = { Host = "example.com" },
      })

      assert.res_status(200, res)
  end)

  teardown(function()
    if proxy_client then proxy_client:close() end
    helpers.stop_kong(nil, true)
  end)
end)

describe("with host set", function()
  local proxy_client

  setup(function()
    local bp = helpers.get_db_utils('postgres', nil, { "redirecting" })

    local route = bp.routes:insert({
      hosts = { "example.com" },
    })
    bp.plugins:insert {
      name = "redirecting",
      route = { id = route.id },
      config = {
        host = 'redirected.com'
      }
    }

    assert(helpers.start_kong({
      database = "postgres",
      plugins = "bundled, redirecting",
      custom_plugins = "redirecting",
      nginx_conf = "spec/fixtures/custom_nginx.template"
    }))

    proxy_client = helpers.proxy_client()
  end)

  describe("GET", function()
    it("is redirected", function()
      local res = proxy_client:get("/", {
        headers = { Host = "example.com" },
      })

      assert.res_status(301, res)
      assert.equal("http://redirected.com/", res.headers["Location"])
    end)
  end)

  describe("POST", function()
    it("is redirected", function()
      local res = proxy_client:post("/create", {
        headers = { Host = "example.com" },
      })

      assert.res_status(301, res)
      assert.equal("http://redirected.com/create", res.headers["Location"])
    end)
  end)

  teardown(function()
    if proxy_client then proxy_client:close() end
    helpers.stop_kong(nil, true)
  end)
end)
