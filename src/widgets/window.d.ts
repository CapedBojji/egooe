interface WindowOptions {
	title?: string;
	closable?: boolean;
	minimizable?: boolean;
	movable?: boolean;
	resizable?: boolean;
	scrollX?: boolean;
	scrollY?: boolean;
	size?: Vector2;
	position?: Vector2;
}

interface WindowHandle {
	closed(): boolean;
	minimized(): boolean;
}

declare function window(options: string | WindowOptions, children: () => void): WindowHandle;

declare namespace window {
	export { WindowOptions, WindowHandle };
}

export = window;
