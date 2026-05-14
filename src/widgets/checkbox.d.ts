interface CheckboxOptions {
	checked?: boolean;
	disabled?: boolean;
}

interface CheckboxHandle {
	checked(): boolean;
	clicked(): boolean;
}

declare function checkbox(text: string, options?: CheckboxOptions): CheckboxHandle;

declare namespace checkbox {
	export { CheckboxOptions, CheckboxHandle };
}

export = checkbox;
