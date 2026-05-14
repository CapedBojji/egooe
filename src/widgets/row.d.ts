interface RowOptions {
	padding?: number | UDim;
	alignment?: CastsToEnum<Enum.HorizontalAlignment>;
	verticalAlignment?: CastsToEnum<Enum.VerticalAlignment>;
}

declare function row(options?: RowOptions | (() => void), children?: () => void): void;

declare namespace row {
	export { RowOptions };
}

export = row;
