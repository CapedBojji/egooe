/** Opaque node returned by Runtime.new */
interface EgooENode {
	readonly _nominal_EgooENode: unique symbol;
}

/** Opaque handle returned by Runtime.beginFrame */
interface EgooEContinueHandle {
	readonly _nominal_EgooEContinueHandle: unique symbol;
}

/** Opaque context token returned by Runtime.createContext */
interface EgooEContext<T> {
	readonly _nominal_EgooEContext: unique symbol;
	readonly _type: T;
}

declare const Runtime: {
	new: (rootInstance: Instance) => EgooENode;
	start<TArgs extends unknown[]>(node: EgooENode, callback: (...args: TArgs) => void, ...args: TArgs): void;
	continueFrame<TArgs extends unknown[]>(
		handle: EgooEContinueHandle,
		callback: (...args: TArgs) => void,
		...args: TArgs
	): void;
	beginFrame<TArgs extends unknown[]>(
		node: EgooENode,
		callback: (...args: TArgs) => void,
		...args: TArgs
	): EgooEContinueHandle;
	finishFrame(node: EgooENode): void;
	scope<TArgs extends unknown[], TResult>(fn: (...args: TArgs) => TResult, ...args: TArgs): TResult;
	widget<T extends (...args: any[]) => any>(fn: T): T;
	useState<T>(initialValue: T): LuaTuple<[T, (newValue: T | ((prev: T) => T)) => void]>;
	useInstance<T extends object = Record<string, unknown>>(
		creator: (ref: Partial<T>) => Instance | LuaTuple<[Instance | undefined, Instance?]>,
	): T;
	useEffect(callback: () => (() => void) | void, ...dependencies: defined[]): void;
	useKey(key: string | number): void;
	useRootInstance(): Instance | undefined;
	setEventCallback(
		callback: (instance: Instance, event: string, handler: (...args: unknown[]) => void) => void,
	): void;
	createContext<T>(name: string): EgooEContext<T>;
	useContext<T>(context: EgooEContext<T>): T | undefined;
	provideContext<T>(context: EgooEContext<T>, value: T): void;
};

declare namespace Runtime {
	export { EgooENode, EgooEContinueHandle, EgooEContext };
}

export = Runtime;
