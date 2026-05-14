interface PopupOptions {
	open?: boolean;
	position?: Vector2;
}

declare function popup(options: PopupOptions, children: () => void): void;

declare namespace popup {
	export { PopupOptions };
}

export = popup;
