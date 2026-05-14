interface CollapsingHeaderHandle {
	open(): boolean;
}

declare function collapsingHeader(text: string, children: () => void): CollapsingHeaderHandle;

declare namespace collapsingHeader {
	export { CollapsingHeaderHandle };
}

export = collapsingHeader;
