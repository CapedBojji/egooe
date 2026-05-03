--- @class IrisPlasma
-- An immediate-mode UI framework for Roblox with Iris visual style and Plasma-compatible API.
-- No automatic sizing: all widgets use explicit sizes.

local Runtime = require(script.Runtime)
local Style = require(script.Style)

return {
	-- Runtime API (Plasma-compatible)
	new = Runtime.new,
	start = Runtime.start,
	continueFrame = Runtime.continueFrame,
	beginFrame = Runtime.beginFrame,
	finishFrame = Runtime.finishFrame,
	scope = Runtime.scope,
	widget = Runtime.widget,
	useState = Runtime.useState,
	useInstance = Runtime.useInstance,
	useEffect = Runtime.useEffect,
	useKey = Runtime.useKey,
	setEventCallback = Runtime.setEventCallback,
	createContext = Runtime.createContext,
	useContext = Runtime.useContext,
	provideContext = Runtime.provideContext,

	-- Style API
	useStyle = Style.get,
	setStyle = Style.set,

	-- Utilities
	create = require(script.create),

	-- Widgets
	window = require(script.widgets.window),
	button = require(script.widgets.button),
	checkbox = require(script.widgets.checkbox),
	slider = require(script.widgets.slider),
	label = require(script.widgets.label),
	heading = require(script.widgets.heading),
	separator = require(script.widgets.separator),
	input = require(script.widgets.input),
	row = require(script.widgets.row),
	space = require(script.widgets.space),
	portal = require(script.widgets.portal),
}
