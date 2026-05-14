interface RadioButtonOptions {
	selected?: boolean;
	disabled?: boolean;
}

interface RadioButtonHandle {
	selected(): boolean;
	clicked(): boolean;
}

declare function radioButton(text: string, options?: RadioButtonOptions): RadioButtonHandle;

declare namespace radioButton {
	export { RadioButtonOptions, RadioButtonHandle };
}

export = radioButton;
