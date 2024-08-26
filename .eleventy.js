const eleventySass = require("@11tyrocks/eleventy-plugin-sass-lightningcss");
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const mdxPlugin = require("@jamshop/eleventy-plugin-mdx");

module.exports = function (eleventyConfig) {
	eleventyConfig.addPlugin(syntaxHighlight);
  eleventyConfig.addPlugin(eleventySass);
  eleventyConfig.addPassthroughCopy("src/media");
  eleventyConfig.addPassthroughCopy("src/content");
  eleventyConfig.addPlugin(mdxPlugin);
  return {
    dir: {
      input: "src",
      output: "public",
    },
  };
};