interface ButtonOptions {
	width?: number | UDim;
	disabled?: boolean;
}

interface ButtonHandle {
	clicked(): boolean;
}

declare function button(text: string, options?: ButtonOptions): ButtonHandle;

declare namespace button {
	export { ButtonOptions, ButtonHandle };
}

export = button;
