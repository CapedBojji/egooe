interface ProgressBarOptions {
	value: number;
	label?: string;
}

declare function progressBar(options: ProgressBarOptions): void;

declare namespace progressBar {
	export { ProgressBarOptions };
}

export = progressBar;
