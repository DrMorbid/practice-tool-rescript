const projectLambdaDelete = require('./src/project/Project_Lambda_Delete.res.js');
exports.projectLambdaDelete = projectLambdaDelete.handler;

const projectLambdaGet = require('./src/project/Project_Lambda_Get.res.js');
exports.projectLambdaGet = projectLambdaGet.handler;

const projectLambdaGetAll = require('./src/project/Project_Lambda_GetAll.res.js');
exports.projectLambdaGetAll = projectLambdaGetAll.handler;

const projectLambdaSave = require('./src/project/Project_Lambda_Save.res.js');
exports.projectLambdaSave = projectLambdaSave.handler;

const sessionLambdaGet = require('./src/session/Session_Lambda_Get.res.js');
exports.sessionLambdaGet = sessionLambdaGet.handler;

const sessionLambdaSave = require('./src/session/Session_Lambda_Save.res.js');
exports.sessionLambdaSave = sessionLambdaSave.handler;

const historyLambdaGet = require('./src/history/History_Lambda_Get.res.js');
exports.historyLambdaGet = historyLambdaGet.handler;