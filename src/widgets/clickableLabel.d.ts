interface ClickableLabelOptions {
	textSize?: number;
	color?: Color3;
}

interface ClickableLabelHandle {
	clicked(): boolean;
}

declare function clickableLabel(text: string, options?: ClickableLabelOptions): ClickableLabelHandle;

declare namespace clickableLabel {
	export { ClickableLabelOptions, ClickableLabelHandle };
}

export = clickableLabel;
