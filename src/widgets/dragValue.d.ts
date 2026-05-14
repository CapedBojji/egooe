interface DragValueOptions {
	min?: number;
	max?: number;
	initial?: number;
	step?: number;
	label?: string;
}

declare function dragValue(options?: DragValueOptions): number;

declare namespace dragValue {
	export { DragValueOptions };
}

export = dragValue;
