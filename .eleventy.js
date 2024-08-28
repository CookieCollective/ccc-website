const eleventySass = require("@11tyrocks/eleventy-plugin-sass-lightningcss");
const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const mdxPlugin = require("@jamshop/eleventy-plugin-mdx");

module.exports = function (eleventyConfig) {
	eleventyConfig.addPlugin(syntaxHighlight);
  eleventyConfig.addPlugin(eleventySass);
  eleventyConfig.addPassthroughCopy("src/media");
  eleventyConfig.addPassthroughCopy("src/content");
  eleventyConfig.addPlugin(mdxPlugin);
  eleventyConfig.addFilter("shuffle", function(array) {
      let shuffledArray = array.slice();
      for (let i = shuffledArray.length - 1; i > 0; i--) {
          const j = Math.floor(Math.random() * (i + 1));
          [shuffledArray[i], shuffledArray[j]] = [shuffledArray[j], shuffledArray[i]];
      }
      return shuffledArray;
  });

  return {
    dir: {
      input: "src",
      output: "public",
    },
  };
};