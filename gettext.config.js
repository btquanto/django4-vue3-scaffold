module.exports = {
  input: {
    path: "./frontend/src", // only files in this directory are considered for extraction
    include: ["**/*.js", "**/*.ts", "**/*.vue"], // glob patterns to select files for extraction
    exclude: [], // glob patterns to exclude files from extraction
  },
  output: {
    path: "./frontend/src/locales", // output path of all created files
    potPath: "./messages.po", // relative to output.path, so by default "./frontend/src/locales/messages.pot"
    jsonPath: "./translations.json", // relative to output.path, so by default "./frontend/src/locales/translations.json"
    locales: ["en", "ja"],
    flat: true, // don't create subdirectories for locales
    linguas: true, // create a LINGUAS file
    splitJson: false, // create separate json files for each locale. If used, jsonPath must end with a directory, not a file
  },
};
