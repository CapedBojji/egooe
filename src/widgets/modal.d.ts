interface ModalOptions {
	title?: string;
	open?: boolean;
	closable?: boolean;
}

interface ModalHandle {
	closed(): boolean;
}

declare function modal(options: string | ModalOptions, children: () => void): ModalHandle;

declare namespace modal {
	export { ModalOptions, ModalHandle };
}

export = modal;
