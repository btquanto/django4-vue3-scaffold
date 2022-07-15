import { createGettext } from "vue3-gettext";
import translations from "@/locales/translations.json";

export const LANGUAGES = {
  en: "English",
  ja: "Japanese",
};

const gettext = createGettext({
  availableLanguages: LANGUAGES,
  defaultLanguage: "en",
  translations: translations,
});

export const $gettext = gettext.$gettext;
export const $pgettext = gettext.$pgettext;
export const $ngettext = gettext.$ngettext;
export const $npgettext = gettext.$npgettext;
export const $interpolate = gettext.$interpolate;

export default gettext;
