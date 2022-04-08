import { safeAsync } from "./async";

export default async function $fetch(...args) {
  let res, error;
  [res, error] = await safeAsync(fetch(...args));
  if (res) {
    [res, error] = await safeAsync(res.json());
  }
  return [res, error];
}
