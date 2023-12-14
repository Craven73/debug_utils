local mod = get_mod("debug_utils")
mod:io_dofile("debug_utils/scripts/mods/debug_utils/components/debug_drawer")

DebugManager = class("DebugManager")
QuickDrawer = QuickDrawer or true
QuickDrawerStay = QuickDrawerStay or true

DebugManager.init = function (self, world, free_flight_manager, input_manager, network_event_delegate, is_server)
	self._world = world
	self._drawers = {}
	-- self.free_flight_manager = free_flight_manager
	-- self.input_manager = input_manager
	-- self.input_service = self.input_manager:get_service("Debug")
	-- self.is_server = is_server
	-- self._actor_draw = {}
	-- self._paused = false
	-- self._visualize_units = {}
	QuickDrawer = self:drawer({
		name = "quick_debug",
		mode = "immediate"
	})
	QuickDrawerStay = self:drawer({
		name = "quick_debug_stay",
		mode = "retained"
	})
	-- self.time_paused = false
	-- self.time_scale_index = table.find(time_scale_list, 100)
	-- self.time_scale_accumulating_value = 0
	-- self.speed_scale_index = table.find(speed_scale_list, 100)
	-- self.graph_drawer = GraphDrawer:new(world, input_manager)
	-- self.network_event_delegate = network_event_delegate

	-- network_event_delegate:register(self, unpack(RPCS))

	-- self.time_scale_list = time_scale_list
	-- self._debug_updates = {}
end

DebugManager.drawer = function (self, options)
	options = options or {}
	local drawer_name = options.name
	local drawer = nil
	local drawer_api = BUILD == "release" and DebugDrawerRelease or DebugDrawer

	if drawer_name == nil then
		local line_object = World.create_line_object(self._world)
		drawer = drawer_api:new(line_object, options.mode)
		self._drawers[#self._drawers + 1] = drawer
	elseif self._drawers[drawer_name] == nil then
		local line_object = World.create_line_object(self._world)
		drawer = drawer_api:new(line_object, options.mode)
		self._drawers[drawer_name] = drawer
	else
		drawer = self._drawers[drawer_name]
	end

	return drawer
end

DebugManager.update = function (self, dt, t)
    for drawer_name, drawer in pairs(self._drawers) do
		drawer:update(self._world)
	end
end