return {
    "windwp/nvim-ts-autotag",
    config = function()
        local status_ok, nvim_ts_autotag = pcall(require, "nvim-ts-autotag")
        if not status_ok then
            print("nvim-ts-autotag could not be found or installed")
            return
        end
        nvim_ts_autotag.setup()

    end
}
