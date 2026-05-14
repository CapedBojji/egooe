interface TableRowOptions {
	header?: boolean;
}

declare function tableRow(
	options?: TableRowOptions | (() => void),
	children?: () => void,
): void;

declare namespace tableRow {
	export { TableRowOptions };
}

export = tableRow;
