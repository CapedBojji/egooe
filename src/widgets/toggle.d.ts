interface ToggleOptions {
	on?: boolean;
	disabled?: boolean;
}

interface ToggleHandle {
	on(): boolean;
	clicked(): boolean;
}

declare function toggle(text: string, options?: ToggleOptions): ToggleHandle;

declare namespace toggle {
	export { ToggleOptions, ToggleHandle };
}

export = toggle;
