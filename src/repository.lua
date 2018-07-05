---
--- Created by Mikhail Epatko.
--- Date: 09.04.18
---

local repository = {}

local define = DEFINE
local fiber = require('fiber')

--======================= uuids space ============================         +++

function repository.uuids_get_by_id(id)
    return box.space.uuids:select { id }
end

function repository.uuids_get_by_ntfp(ntfp)
    return box.space.uuids.index.ntfp:select { ntfp }
end

function repository.uuids_get_by_ntid(ntid)
    return box.space.uuids.index.ntid:select { ntid }
end

function repository.uuids_get_by_uuid(uuid)
    return box.space.uuids.index.uuid:select { uuid }
end

function repository.uuids_save(args)
    return box.space.uuids:insert { nil, args.ntfp, args.ntid, args.uuid, fiber.time() }
end

function repository.uuids_update_tuple(args)
    for k,v in pairs(args) do print(k, v) end
    box.space.uuids:update(args.id, { { '=', define.UUIDS_NTFP, args.ntfp },
                                      { '=', define.UUIDS_NTID, args.ntid },
                                      { '=', define.UUIDS_UUID, args.uuid },
                                      { '=', define.UUIDS_CREATED, fiber.time() } })
end

function repository.delete(tuple)
    return box.space.uuids:delete { tuple[define.UUIDS_ID] }
end

-- ... repositories for other spaces below ...

return repository