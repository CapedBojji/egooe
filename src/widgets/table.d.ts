interface TableColumn {
	width?: number;
	fill?: boolean;
}

interface TableOptions {
	columns?: TableColumn[];
	header?: boolean;
	rowHeight?: number;
	cellPadding?: Vector2;
	borders?: boolean;
	stripeRows?: boolean;
	stripeColumns?: boolean;
	stripeRowColor?: Color3;
	stripeColumnColor?: Color3;
	stripeRowTransparency?: number;
	stripeColumnTransparency?: number;
}

declare function table(options: TableOptions, children: () => void): void;

declare namespace table {
	export { TableColumn, TableOptions };
}

export = table;
