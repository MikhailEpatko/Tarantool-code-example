---
--- Created by Mikhail Epatko.
--- Date: 09.04.18
---

PORT_NUMBER = 8080
HOST_NAME = '0.0.0.0'
LOG = require('src.log')
DEFINE = require('src.define')
require('src.controller')

box.cfg {
    listen = 55555,
    log = 'app.log',

    work_dir = './workdir',

    vinyl_memory = 128 * 1024 * 1024,
    vinyl_cache = 128 * 1024 * 1024,
    vinyl_max_tuple_size = 10 * 1024,
    vinyl_read_threads = 1,
    vinyl_write_threads = 2,
    vinyl_timeout = 60,
    vinyl_run_count_per_level = 2,
    vinyl_run_size_ratio = 3.5,
    vinyl_range_size = 1024 * 1024 * 1024,
    vinyl_page_size = 8 * 1024,
    vinyl_bloom_fpr = 0.05
}
box.schema.user.passwd('admin-name', 'admin-password')
box.once('spaces', function()

    --======================= uuids space ============================

    box.schema.sequence.create('s_uuids')
    box.schema.space.create('uuids', { if_not_exists = true }, { engine = 'vinyl' })
    box.space.uuids:create_index('primary', { sequence = 's_uuids' })
    box.space.uuids:create_index('ntfp', {
        type = 'tree',
        unique = false,
        parts = { DEFINE.UUIDS_NTFP, 'str' },
        if_not_exists = true
    })
    box.space.uuids:create_index('ntid', {
        type = 'tree',
        unique = false,
        parts = { DEFINE.UUIDS_NTID, 'str' },
        if_not_exists = true
    })
    box.space.uuids:create_index('uuid', {
        type = 'tree',
        unique = false,
        parts = { DEFINE.UUIDS_UUID, 'str' },
        if_not_exists = true
    })
    box.space.uuids:create_index('created', {
        type = 'tree',
        unique = false,
        parts = { DEFINE.UUIDS_CREATED, 'number' },
        if_not_exists = true
    })

     -- ... other spaces below ...



end)