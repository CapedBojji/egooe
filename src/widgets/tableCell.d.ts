interface TableCellOptions {
	column?: number;
}

declare function tableCell(children: () => void): void;
declare function tableCell(options: TableCellOptions, children: () => void): void;

declare namespace tableCell {
	export { TableCellOptions };
}

export = tableCell;
