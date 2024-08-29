const eleventySass = require("@11tyrocks/eleventy-plugin-sass-lightningcss");
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const mdxPlugin = require("@jamshop/eleventy-plugin-mdx");
const eleventyPluginPhosphoricons = require('eleventy-plugin-phosphoricons');

module.exports = function (config) {
	config.addPlugin(syntaxHighlight);
  config.addPlugin(eleventySass);
  config.addPassthroughCopy("src/media");
  config.addPassthroughCopy("src/content");
  config.addPlugin(mdxPlugin);
  config.addFilter("shuffle", function(array) {
      let shuffledArray = array.slice();
      for (let i = shuffledArray.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [shuffledArray[i], shuffledArray[j]] = [shuffledArray[j], shuffledArray[i]];
      }
      return shuffledArray;
  });
  config.addPlugin(eleventyPluginPhosphoricons, {
        class: "phicon",
        style: "vertical-align: middle;",
        size: 32,
        fill: "currentColor"
    });

  return {
    dir: {
      input: "src",
      output: "public",
    },
  };
};