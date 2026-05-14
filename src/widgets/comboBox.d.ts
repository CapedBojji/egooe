interface ComboBoxOptions {
	items: string[];
	selected?: string;
	label?: string;
}

interface ComboBoxHandle {
	value(): string;
	changed(): boolean;
}

declare function comboBox(options: ComboBoxOptions): ComboBoxHandle;

declare namespace comboBox {
	export { ComboBoxOptions, ComboBoxHandle };
}

export = comboBox;
