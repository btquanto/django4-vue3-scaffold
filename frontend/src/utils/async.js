export async function safeAsync(promise) {
  try {
    return [await promise, null];
  } catch (error) {
    return [null, error];
  }
}
