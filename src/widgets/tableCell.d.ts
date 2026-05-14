interface TableCellOptions {
	column?: number;
}

declare function tableCell(
	options?: TableCellOptions | (() => void),
	children?: () => void,
): void;

declare namespace tableCell {
	export { TableCellOptions };
}

export = tableCell;
