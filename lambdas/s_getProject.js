
var serverlessSDK = require('./serverless_sdk/index.js');
serverlessSDK = new serverlessSDK({
  orgId: 'morbo',
  applicationName: 'practice-tool-rescript',
  appUid: 'JdZWdcqgYT6zM3rDLt',
  orgUid: 'ttQSf0pbwxc3dyD5J4',
  deploymentUid: '95ccf28a-0cfd-4bae-88f2-aae7faf63808',
  serviceName: 'practice-tool-rescript',
  shouldLogMeta: true,
  shouldCompressLogs: true,
  disableAwsSpans: false,
  disableHttpSpans: false,
  stageName: 'dev',
  serverlessPlatformStage: 'prod',
  devModeEnabled: false,
  accessKey: null,
  pluginVersion: '7.2.0',
  disableFrameworksInstrumentation: false
});

const handlerWrapperArgs = { functionName: 'practice-tool-rescript-dev-getProject', timeout: 6 };

try {
  const userHandler = require('./src/project/Project_Lambda_Get.res.js');
  module.exports.handler = serverlessSDK.handler(userHandler.handler, handlerWrapperArgs);
} catch (error) {
  module.exports.handler = serverlessSDK.handler(() => { throw error }, handlerWrapperArgs);
}