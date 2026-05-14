interface InputOptions {
	text?: string;
	placeholder?: string;
	label?: string;
}

interface InputHandle {
	value(): string;
	changed(): boolean;
	submitted(): boolean;
}

declare function input(options?: InputOptions): InputHandle;

declare namespace input {
	export { InputOptions, InputHandle };
}

export = input;
