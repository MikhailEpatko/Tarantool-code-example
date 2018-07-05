---
--- Created by Mikhail Epatko.
--- Date: 09.04.18
---

local service = {}

local validator = require('src.validator')
local repository = require('src.repository')
local utilities = require('src.utilities')
local define = DEFINE
local log = LOG

function service.identity(ntfp, ntid)
    if not validator.not_empty_string(ntfp) and not validator.not_empty_string(ntid) then
        return nil, 'Ntfp and NtId is empty or not a string value.', 'error'
    end
    local tuples = repository.uuids_get_by_ntfp(ntfp)
    if #tuples > 0 then
        local tuple = utilities.select_one(tuples)
        return tuple[define.UUIDS_UUID], 'OK', 'success'
    else
        log.debug(string.format("UUID by ntfp: %s is not found. Trying to search by ntid...", ntfp))
        tuples = repository.uuids_get_by_ntid(ntid)
        if #tuples > 0 then
            local tuple = utilities.select_one(tuples)
            utilities.update_ntfp_in_tuple(tuple, ntfp)
            return tuple[define.UUIDS_UUID], 'OK', 'success'
        else
            log.debug(string.format("UUID by ntid: %s is not found. Trying to create new UUID...", ntid))
            local tuple, message, status = service.create_uuid(ntfp, ntid)
            local uuid
            if tuple then
                uuid = tuple[define.UUIDS_UUID]
            end
            return uuid, message, status
        end
    end
end

function service.create_uuid(ntfp, ntid)
    local uuid = utilities.get_uuid()


    local args = utilities.prepare_args(ntfp, ntid, uuid)
    local fine, tuple_or_reason = pcall(repository.uuids_save, args)
    if fine then
        log.debug(string.format("Created new UUID for ntfp: %s, ntid: %s. UUID: %s.", ntfp, ntid, uuid))
        return tuple_or_reason, 'Created new UUID.', 'success'
    else
        local message = string.format("Can't save new tuple for ntfp: %s, ntid: %s, uuid: %s. Reason: %s", ntfp, ntid, uuid, tuple_or_reason)
        log.error(message)
        return nil, message, 'error'
    end
end

return service