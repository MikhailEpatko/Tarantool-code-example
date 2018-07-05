---
--- Created by Mikhail Epatko.
--- Date: 09.04.18
---

local controller = {}

local httpd = require('http.server').new(HOST_NAME, PORT_NUMBER)
local service_identity = require('src.service_uuid')

function controller.uuid_handler(req)
    local jsonbody = req:json()
    local uuid, message, status = service_identity.identity(jsonbody.ntfp, jsonbody.ntid);
    local answer = { uuid = uuid, message = message, status = status }
    return req:render({ json = answer })
end

-- ...other handlers below ...

httpd:route({ path = '/uuid' }, controller.uuid_handler)

 -- ... other entry points below...

httpd:start()

return controller