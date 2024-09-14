local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error("omnivore.nvim requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
    exports = {
        notes = require("telescope._extensions.notes"),
    },
})
