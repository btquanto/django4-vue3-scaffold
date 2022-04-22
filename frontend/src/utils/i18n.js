import { createGettext } from "vue3-gettext";
import translations from "@/locales/translations.json";

export const LANGUAGES = {
  en: "English",
  ja: "Japanese",
};

export default createGettext({
  availableLanguages: LANGUAGES,
  defaultLanguage: "en",
  translations: translations,
});
