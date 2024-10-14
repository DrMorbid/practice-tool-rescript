import { client, getBucketName } from "./awsCommon.js";
import { ListObjectsCommand } from "@aws-sdk/client-s3";

client.send(new ListObjectsCommand({
 Bucket: getBucketName(false)
})).then((result) => console.log(result))
