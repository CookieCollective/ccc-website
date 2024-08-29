const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');
const slugify = require('slugify');

module.exports = function() {
  const projectsJson = JSON.parse(fs.readFileSync('./src/_data/projects.json', 'utf8'));

  function titleToSlug(title) {
    return slugify(title, { lower: true, strict: true });
  }

  function loadMarkdownContent(projectSlug, fileName) {
    const fullPath = path.join('./src/content/projects', projectSlug, fileName);
    if (fs.existsSync(fullPath)) {
      const fileContent = fs.readFileSync(fullPath, 'utf8');
      const { content } = matter(fileContent);
      return content;
    }
    return `Content not found for ${fileName}`;
  }

  const processedProjects = projectsJson.map(project => {
    const projectSlug = titleToSlug(project.folder);

    if (project.videast) {
      project.videast.bio = loadMarkdownContent(projectSlug, 'videast_bio.html');
      project.videast.description = loadMarkdownContent(projectSlug, 'videast_description.html');
    }

    if (project.musician) {
      project.musician.bio = loadMarkdownContent(projectSlug, 'musician_bio.html');
      project.musician.description = loadMarkdownContent(projectSlug, 'musician_description.html');
    }

    return project;
  });

  return processedProjects;
};