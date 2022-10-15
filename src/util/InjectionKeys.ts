import { InjectionKey } from "vue";

export const InitialDataKey = Symbol('InitialDataKey') as InjectionKey<Record<string, any>>