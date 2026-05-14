interface LabelOptions {
	textSize?: number;
	color?: Color3;
	wrapped?: boolean;
}

declare function label(text: string, options?: LabelOptions): void;

declare namespace label {
	export { LabelOptions };
}

export = label;
