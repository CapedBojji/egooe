interface EgooEStyle {
	// Text
	textColor: Color3;
	textDisabledColor: Color3;
	textSize: number;

	// Window / panel backgrounds
	windowBgColor: Color3;
	windowBgTransparency: number;
	popupBgColor: Color3;

	// Title bar
	titleBgColor: Color3;
	titleBgActiveColor: Color3;

	// Frame (inputs, checkboxes, etc.)
	frameBgColor: Color3;
	frameBgTransparency: number;
	frameBgHoveredColor: Color3;
	frameBgHoveredTransparency: number;

	// Buttons
	buttonColor: Color3;
	buttonTransparency: number;
	buttonHoveredColor: Color3;
	buttonHoveredTransparency: number;
	buttonActiveColor: Color3;
	buttonActiveTransparency: number;

	// Slider
	sliderGrabColor: Color3;

	// Checkbox
	checkMarkColor: Color3;

	// Separator
	separatorColor: Color3;
	separatorTransparency: number;

	// Border
	borderColor: Color3;
	borderTransparency: number;

	// Scrollbar
	scrollbarGrabColor: Color3;

	// Collapsing header
	headerColor: Color3;
	headerTransparency: number;

	// SelectableLabel highlight
	selectableColor: Color3;
	selectableTransparency: number;

	// Toggle switch
	toggleOnColor: Color3;
	toggleOffColor: Color3;
	toggleHandleColor: Color3;

	// Modal overlay backdrop
	modalOverlayColor: Color3;
	modalOverlayTransparency: number;

	// Table
	tableHeaderColor: Color3;
	tableHeaderTransparency: number;
	tableStripeRowColor: Color3;
	tableStripeRowTransparency: number;
	tableStripeColumnColor: Color3;
	tableStripeColumnTransparency: number;
	tableBorderColor: Color3;
	tableBorderTransparency: number;
	tableRowHeight: number;
	tableCellPadding: Vector2;

	// Sizing
	framePadding: Vector2;
	itemSpacing: Vector2;
	windowPadding: Vector2;
	itemHeight: number;
	titleBarHeight: number;
	scrollbarSize: number;
}

declare const Style: {
	get: () => EgooEStyle;
	set: (tokens: Partial<EgooEStyle>) => void;
};

declare namespace Style {
	export { EgooEStyle };
}

export = Style;
