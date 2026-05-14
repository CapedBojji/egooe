declare function create<T extends keyof CreatableInstances>(
	className: T,
	props?: { [key: string]: unknown },
): CreatableInstances[T];

export = create;
