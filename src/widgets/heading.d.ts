interface HeadingOptions {
	textSize?: number;
	font?: CastsToEnum<Enum.Font>;
}

declare function heading(text: string, options?: HeadingOptions): void;

declare namespace heading {
	export { HeadingOptions };
}

export = heading;
