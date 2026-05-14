interface SliderOptions {
	min?: number;
	max?: number;
	initial?: number;
	label?: string;
	width?: number;
}

declare function slider(options?: SliderOptions | number): number;

declare namespace slider {
	export { SliderOptions };
}

export = slider;
