export function assign(self, ...items) {
  /** Assign the attributes of items to self for all attributes that exists in self */

  if (self === null || self === undefined) {
    self = {};
  }

  if (self && items.length > 0) {
    items.forEach((item) => {
      if (item !== undefined && item !== null)
        Object.keys(item).forEach((key) => {
          if (self[key] !== undefined && item[key] !== undefined) self[key] = item[key];
        });
    });
  }
  return self;
}

export function uuid(length = 8) {
  // Public Domain/MIT
  let d = new Date().getTime(); //Timestamp
  let d2 = (performance && performance.now && performance.now() * 1000) || 0;
  //Time in microseconds since page-load or 0 if unsupported
  return Array.from(Array(length))
    .map((_) => "x")
    .join()
    .replace(/[x]/g, function (c) {
      let r = Math.random() * 16; //random number between 0 and 16
      if (d > 0) {
        //Use timestamp until depleted
        r = (d + r) % 16 | 0;
        d = Math.floor(d / 16);
      } else {
        //Use microseconds since page-load if supported
        r = (d2 + r) % 16 | 0;
        d2 = Math.floor(d2 / 16);
      }
      return (c === "x" ? r : (r & 0x3) | 0x8).toString(16);
    });
}
