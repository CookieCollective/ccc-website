local GITEA_CREDENTIALS = {
  password: '((gitea-access-token))',
  username: 'concourse',
};
local GITEA_HOST = 'gitea.cookie.paris';

local DOCKER_IMAGE_RESOURCE = {
  name: 'docker-image',
  source: GITEA_CREDENTIALS {
    repository: GITEA_HOST + '/collective/ccc-website',
    tag: 'latest',
  },
  type: 'registry-image',
};

local GIT_REPOSITORY_RESOURCE = {
  name: 'git-repository',
  source: {
    uri: 'https://github.com/CookieCollective/ccc-website.git',
  },
  type: 'git',
  webhook_token: '((webhook-token))',
};

local BUILD_DOCKER_IMAGE_TASK = {
  caches: [
    {
      path: 'cache',
    },
  ],
  image_resource: {
    source: {
      repository: 'concourse/oci-build-task',
    },
    type: 'registry-image',
  },
  inputs: [
    {
      name: GIT_REPOSITORY_RESOURCE.name,
      path: '.',
    },
  ],
  outputs: [
    {
      name: 'image',
    },
  ],
  platform: 'linux',
  run: {
    path: 'build',
  },
};

{
  'pipelines-main.json': {
    jobs: [
      {
        local JSONNET_OUTPUT = '.concourse',
        name: 'update-pipelines',
        plan: [
          {
            get: GIT_REPOSITORY_RESOURCE.name,
            params: {
              depth: 1,
            },
            trigger: true,
          },
          {
            task: 'generate-concourse-files',
            config: {
              image_resource: {
                source: {
                  repository: 'bitnami/jsonnet',
                },
                type: 'registry-image',
              },
              inputs: [
                {
                  name: GIT_REPOSITORY_RESOURCE.name,
                },
              ],
              outputs: [
                {
                  name: JSONNET_OUTPUT,
                },
              ],
              platform: 'linux',
              run: {
                args: [
                  '-m',
                  JSONNET_OUTPUT,
                  GIT_REPOSITORY_RESOURCE.name + '/concourse.jsonnet',
                ],
                path: 'jsonnet',
                user: 'root',
              },
            },
          },
          {
            file: JSONNET_OUTPUT + '/pipelines-main.json',
            set_pipeline: 'ccc-website',
          },
        ],
        public: true,
      },
      {
        name: 'build',
        plan: [
          {
            get: GIT_REPOSITORY_RESOURCE.name,
            params: {
              depth: 1,
            },
            passed: [
              'update-pipelines',
            ],
            trigger: true,
          },
          {
            config: BUILD_DOCKER_IMAGE_TASK,
            privileged: true,
            task: 'build-docker-image',
          },
          {
            put: DOCKER_IMAGE_RESOURCE.name,
            params: {
              image: 'image/image.tar',
            },
          },
        ],
        public: true,
      },
    ],
    resources: [
      DOCKER_IMAGE_RESOURCE,
      GIT_REPOSITORY_RESOURCE,
    ],
  },
  'tasks-build-docker-image.json': BUILD_DOCKER_IMAGE_TASK,
}
