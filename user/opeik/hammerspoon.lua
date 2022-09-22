-- See: <https://www.hammerspoon.org/docs/hs.caffeinate.watcher.html>
local watcher = hs.caffeinate.watcher

local function execute(cmd, error_msg)
    local did_succeed, _, exit_code = os.execute(cmd)
    if not did_succeed then
        hs.notify.new({
            title = error_msg,
            informativeText = string.format("Command `%s` failed with exit code %d", cmd, exit_code)
        }):send()
    end
end

local function wake()
    execute("shortcuts run 'Turn speakers on'", "Failed to turn on speakers")
end

local function sleep()
    execute("shortcuts run 'Turn speakers off'", "Failed to turn off speakers")
end

local function power_callback(event)
    local callback = ({
        [watcher.screensDidUnlock] = wake,
        [watcher.screensDidWake] = wake,
        [watcher.systemDidWake] = wake,

        [watcher.screensDidSleep] = sleep,
        [watcher.systemWillSleep] = sleep,
        [watcher.systemWillPowerOff] = sleep,
    })[event]

    if callback ~= nil then
        callback()
    end
end

watcher.new(power_callback):start()
