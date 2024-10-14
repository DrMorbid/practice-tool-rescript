const { readdir, readFile } = require('fs/promises');

const readDirectory = async (path = './') => {
 const filesInPath = await readdir(path, { withFileTypes: true, recursive: true });

 const files = filesInPath.filter(file => !file.isDirectory()).map(({ name, parentPath }) => `${parentPath}/${name}`);

 // This will go to S3 Body
 const buffer = await readFile(files.at(0))

 console.log("first file's content is %o", buffer);

 // This will go to S3 Key
 return files.map(file => file.substring(file.indexOf("/out") + 5));
};

readDirectory("/home/filip/development/practice-tool-rescript/frontend/out")
 .then(files => console.log(files));

import { Upload } from "@aws-sdk/lib-storage";

const upl = new Upload({
 params: {
  ContentType: ""
 }
});