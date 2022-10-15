export function addInitialData(ctx: Record<string, any>, key: string, value: any) {
  getInitialData(ctx)[key] = value
}

export function getInitialData(ctx: Record<string, any>) {
  if (! ('_initialData' in ctx)) {
    ctx['_initialData'] = {}
  }
  return ctx['_initialData']
}