import { S3Client } from "@aws-sdk/client-s3";

const client = new S3Client({});

const getBucketName = isProd => isProd ? "practice-tool" : "practice-tool-dev";

export { client, getBucketName };
