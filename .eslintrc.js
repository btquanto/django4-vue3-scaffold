module.exports = {
  extends: ["plugin:vue/recommended", "plugin:prettier/recommended", "eslint:recommended"],
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
  },
  rules: {
    "no-undef": "warn",
    "no-unused-vars": [
      "warn",
      {
        argsIgnorePattern: "(^_)|(^h$)",
        varsIgnorePattern: "^_",
      },
    ],
    "no-case-declarations": "off",
    "prettier/prettier": [
      "warn",
      {
        bracketSameLine: true,
        bracketSpacing: true,
        htmlWhiteSpaceSensitivity: "ignore",
        jsxSingleQuote: false,
        printWidth: 180,
        quoteProps: "consistent",
        singleQuote: false,
        tabWidth: 2,
        trailingComma: "es5",
      },
      {
        usePrettierrc: false,
      },
    ],
    "vue/html-closing-bracket-newline": "off",
    "vue/html-indent": "off",
    "vue/html-self-closing": "off",
    "vue/max-attributes-per-line": "off",
    "vue/no-unused-components": "warn",
    "vue/no-unused-vars": "warn",
    "vue/require-v-for-key": "warn",
    "vue/v-slot-style": "off",
    "vue/no-multiple-template-root": "off",
  },
  globals: {
    $: true,
    __dirname: true,
    module: true,
    process: true,
    require: true,
  },
};
