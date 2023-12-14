local mod = get_mod("debug_utils")
mod:io_dofile("debug_utils/scripts/mods/debug_utils/components/debug_manager")
mod:io_dofile("debug_utils/scripts/mods/debug_utils/components/debug_text")

local enabled = true
mod.debug_manager = nil
mod.debug_gui = nil
mod.debug_text = nil


mod.on_enabled = function() 
  pcall(function()
    local world = Managers.world:world("level_world")
    if world ~= nil then
      mod.debug_gui = World.create_screen_gui(world, "immediate")
      mod.debug_manager = DebugManager:new(world, nil, nil, nil, true)
      mod.debug_text = DebugTextManager:new(world, mod.debug_gui, true, nil)
    end
  end)
end

mod.on_game_state_changed = function(status, state)
  if status == "enter" and state == "GameplayStateRun" then
    local world = Managers.world:world("level_world")
    mod.debug_gui = World.create_screen_gui(world, "immediate")
    mod.debug_manager = DebugManager:new(world, nil, nil, nil, true)
    mod.debug_text = DebugTextManager:new(world, mod.debug_gui, true, nil)
  else 
    mod.debug_gui = nil
    mod.debug_manager = nil
    mod.debug_text = nil
  end
end

mod:command("enable", "", function() 
  enabled = not enabled
  local local_player = Managers.player:local_player(1)
  local local_player_unit = local_player.player_unit
  local world = Unit.world(local_player_unit)
  mod.debug_gui = World.create_screen_gui(world, "immediate")
  mod.debug_manager = DebugManager:new(world, nil, nil, nil, true)
  mod.debug_text = DebugTextManager:new(world, mod.debug_gui, true, nil)
  mod:echo(enabled)
  local local_player = Managers.player:local_player(1)

  mod:echo(local_player.viewport_name)
end)


-- mod:command("drawer", "", function() 
--   local local_player = Managers.player:local_player(1)
--   local local_player_unit = local_player.player_unit
--   local current_position = Unit.local_position(local_player_unit, 1)
--   local h = Vector3(0, 0, 1)
--   QuickDrawerStay:sphere(current_position, 0.25, Color.light_green())
-- end)
-- mod:hook_safe(CLASS.CinematicSceneSystem, "play_cutscene", function (self, ...)
--   mod:echo("Play Cutscene Hook")
--   local local_player = Managers.player:local_player(1)
--   local local_player_unit = local_player.player_unit
--   local world = Unit.world(local_player_unit)
--   mod.debug_manager = DebugManager:new(world, nil, nil, nil, true)
-- end)


-- mod.on_enabled = function() 
--   local world = Managers.world:world("level_world")
--   mod.debug_manager = DebugManager:new(world, nil, nil, nil, true)
-- end

mod.update = function(dt, t)
  if enabled and mod.debug_manager and mod.debug_text then 
    local status = pcall(function()
      mod.debug_manager:update(dt, t)
      local local_player = Managers.player:local_player(1)
      mod.debug_text:update(dt, local_player.viewport_name)
    end)

    if not status then
      mod.debug_manager = nil
      mod.debug_text = nil
      mod.debug_gui = nil
    end
  end


end



-- Your mod code goes here.
-- https://vmf-docs.verminti.de
