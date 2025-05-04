Config = {}

-- Enable/Disable Debug Logs
Config.Debug = false -- true = show logs, false = hide logs

-- Model & Animation
Config.MapModel = "prop_tourist_map_01"                   -- Map model to attach
Config.AnimDict = "amb@world_human_clipboard@male@idle_a" -- Animation dictionary
Config.AnimName = "idle_a"                                -- Animation name

-- Allow manually opening/closing map using a key
Config.AllowKeyOpen = false

-- Key for manual open/close (default: G key)
Config.OpenKey = 47 -- [G] key

-- For a full list of key codes, refer to:
-- https://docs.fivem.net/docs/game-references/controls/

-- Settings
Config.CloseOnDeath = true   -- true = close map if player dies
Config.CloseOnFall = true    -- true = close map if player falls or ragdolls
Config.CloseInVehicle = true -- true = close map if player enters a vehicle
Config.CloseOnWeapon = true  -- true = close map if player switches weapon

-- Set the minimum level of logs you want to see in the console
Config.LogLevel = "INFO" -- Options: "INFO", "WARN", "ERROR"

--[[ 

 +--------+-----------------------------------------------+
 | Level  | What It Shows                                 |
 +--------+-----------------------------------------------+
 | INFO   | All logs: info, warnings, and errors          |
 | WARN   | Only warnings and errors                      |
 | ERROR  | Only critical errors (e.g., failed map spawn) |
 +--------+-----------------------------------------------+
 Use "INFO" for development, "WARN" or "ERROR" for live servers.

]]