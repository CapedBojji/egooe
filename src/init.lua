--- @class IrisPlasma
-- An immediate-mode UI framework for Roblox with Iris visual style and Plasma-compatible API.
-- No automatic sizing: all widgets use explicit sizes.

local Runtime = require(script.Runtime)
local Style = require(script.Style)

-- Pre-require widget modules that expose handle types
local _button = require(script.widgets.button)
local _checkbox = require(script.widgets.checkbox)
local _input = require(script.widgets.input)
local _window = require(script.widgets.window)

-- Handle types
type ButtonHandle = _button.ButtonHandle
type CheckboxHandle = _checkbox.CheckboxHandle
type InputHandle = _input.InputHandle
type WindowHandle = _window.WindowHandle

-- Option types
type ButtonOptions = { width: (UDim | number)?, disabled: boolean? }
type CheckboxOptions = { checked: boolean?, disabled: boolean? }
type SliderOptions = { min: number?, max: number?, initial: number?, label: string?, width: number? }
type InputOptions = { text: string?, placeholder: string?, label: string? }
type WindowOptions = {
	title: string?,
	closable: boolean?,
	movable: boolean?,
	resizable: boolean?,
	size: Vector2?,
	position: Vector2?,
}
type LabelOptions = { textSize: number?, color: Color3?, wrapped: boolean? }
type HeadingOptions = { textSize: number?, font: Enum.Font? }
type RowOptions = {
	padding: (number | UDim)?,
	alignment: Enum.HorizontalAlignment?,
	verticalAlignment: Enum.VerticalAlignment?,
}

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
	window = _window :: (options: string | WindowOptions, children: () -> ()) -> WindowHandle,
	button = _button :: (text: string, options: ButtonOptions?) -> ButtonHandle,
	checkbox = _checkbox :: (text: string, options: CheckboxOptions?) -> CheckboxHandle,
	slider = require(script.widgets.slider) :: (options: (SliderOptions | number)?) -> number,
	label = require(script.widgets.label) :: (text: string, options: LabelOptions?) -> (),
	heading = require(script.widgets.heading) :: (text: string, options: HeadingOptions?) -> (),
	separator = require(script.widgets.separator) :: () -> (),
	input = _input :: (options: InputOptions?) -> InputHandle,
	row = require(script.widgets.row) :: (options: (RowOptions | (() -> ()))?, children: (() -> ())?) -> (),
	space = require(script.widgets.space) :: (size: number?) -> (),
	portal = require(script.widgets.portal) :: (targetInstance: Instance, children: () -> ()) -> (),
	demoWindow = require(script.widgets.demoWindow) :: () -> (),
}
