interface ChildWindowOptions {
	title?: string;
	height?: number;
	minimizable?: boolean;
	scrollX?: boolean;
	scrollY?: boolean;
}

interface ChildWindowHandle {
	minimized(): boolean;
}

declare function childWindow(
	options: string | ChildWindowOptions,
	children: () => void,
): ChildWindowHandle;

declare namespace childWindow {
	export { ChildWindowOptions, ChildWindowHandle };
}

export = childWindow;
