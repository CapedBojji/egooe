interface TableRowOptions {
	header?: boolean;
}

declare function tableRow(children: () => void): void;
declare function tableRow(options: TableRowOptions, children: () => void): void;

declare namespace tableRow {
	export { TableRowOptions };
}

export = tableRow;
