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

module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: PUBLIC_PATH,
  outputDir: OUTPUT_DIR,
  pages: Object.fromEntries(
    Object.entries(APPS)
      .map(([app, views]) => {
        return Object.entries(views).map(([view, path]) => {
          return [`${app}_${view}`, path];
        });
      })
      .flat()
  ),
  configureWebpack: {
    performance: {
      hints: false,
    },
    watchOptions: {
      ignored: Path.resolve(__dirname, "node_modules"),
    },
    optimization: {
      runtimeChunk: "multiple",
      splitChunks: {
        cacheGroups: {
          corejs: {
            test: /[\\/]node_modules[\\/]core-js[\\/]/,
            name: "corejs",
            chunks: "all",
          },
          moment: {
            test: /[\\/]node_modules[\\/]moment[\\/]/,
            name: "moment",
            chunks: "all",
          },
          vue: {
            test: /[\\/]node_modules[\\/]vue/,
            name: "vue",
            chunks: "all",
          },
        },
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
    config.output.filename((_) => "[name]-[chunkhash].js");
  },
  css: {
    extract: {
      filename: "[name].css",
      chunkFilename: "[name]-[hash].css",
    },
  },
});
