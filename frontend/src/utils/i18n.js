function _default(text) {
  return text;
}
export const gettext = window.gettext || _default;
export const ngettext = window.ngettext || _default;
export const interpolate = window.interpolate || _default;
