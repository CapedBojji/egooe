interface RowOptions {
	padding?: number | UDim;
	alignment?: CastsToEnum<Enum.HorizontalAlignment>;
	verticalAlignment?: CastsToEnum<Enum.VerticalAlignment>;
}

declare function row(children: () => void): void;
declare function row(options: RowOptions, children: () => void): void;

declare namespace row {
	export { RowOptions };
}

export = row;
