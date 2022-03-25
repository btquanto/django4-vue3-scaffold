const { defineConfig } = require("@vue/cli-service");
const BundleTracker = require("webpack-bundle-tracker");
const Path = require("path");

const PUBLIC_PATH = "/static/";
const OUTPUT_DIR = "./dist/";
const INPUT_DIR = "./frontend/src/";

const APPS = {
  todo: {
    index: { entry: `${INPUT_DIR}/entries/todo/index.js` },
  },
};

const PAGES = {};
Object.keys(APPS).forEach((app) => Object.keys(APPS[app]).forEach((view) => (PAGES[`${app}_${view}`] = APPS[app][view])));

module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: PUBLIC_PATH,
  outputDir: OUTPUT_DIR,
  pages: PAGES,
  configureWebpack: {
    performance: {
      hints: false,
    },
    watchOptions: {
      ignored: Path.resolve(__dirname, "node_modules"),
    },
    optimization: {
      runtimeChunk: {
        name: "runtime",
      },
      splitChunks: {
        chunks: "async",
      },
    },
    resolve: {
      alias: {
        "@": Path.resolve(__dirname, INPUT_DIR),
      },
      extensions: [".js", ".vue", ".json"],
    },
    devServer: {
      public: PUBLIC_PATH,
      injectClient: false,
      injectHot: false,
      hot: false,
      inline: false,
      hotOnly: false,
      https: false,
      watchOptions: {
        poll: 1000,
      },
      disableHostCheck: false,
      headers: { "Access-Control-Allow-Origin": "*" },
    },
  },
  chainWebpack: (config) => {
    config.plugin("BundleTracker").use(BundleTracker, [{ filename: "./webpack-stats.json" }]);
    config.output.filename((opt) => {
      if (opt.chunk.id == "runtime") {
        return "[name].js";
      }
      return "[name]-[chunkhash].js";
    });
    config.resolve.alias.set("__NODE__", Path.resolve(__dirname, "./node_modules"));
  },
  css: {
    extract: {
      filename: "[name].css",
      chunkFilename: "[name]-[hash].css",
    },
  },
});
