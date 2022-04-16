--local present1, autopairs = pcall(require, "nvim-autopairs")
--local present2, autopairs_completion = pcall(require, "nvim-autopairs.completion.compe")

--if not (present1 or present2) then
--    return
--end

-- autopairs.setup()
-- autopairs_completion.setup(
--     {
--         map_cr = true,
--         map_complete = true -- insert () func completion
--     }
-- )

-- If you want insert `(` after select function or method item
local autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', autopairs.on_confirm_done({  map_char = { tex = '' } }))
