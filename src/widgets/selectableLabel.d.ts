interface SelectableLabelOptions {
	selected?: boolean;
	disabled?: boolean;
}

interface SelectableLabelHandle {
	selected(): boolean;
	clicked(): boolean;
}

declare function selectableLabel(text: string, options?: SelectableLabelOptions): SelectableLabelHandle;

declare namespace selectableLabel {
	export { SelectableLabelOptions, SelectableLabelHandle };
}

export = selectableLabel;
