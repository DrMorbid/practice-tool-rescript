# Practice Tool

[![Build Status](https://img.shields.io/badge/Build-Passing-success?style=flat-square)](https://github.com/DrMorbid/practice-tool-rescript)
![Node version](https://img.shields.io/badge/Node.js->=20-3c873a?style=flat-square)
[![ReScript](https://img.shields.io/badge/ReScript-11.1.4-e6484f?style=flat-square&logo=rescript&logoColor=white)](https://rescript-lang.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-blue?style=flat-square&logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

A serverless web application designed to help you track and optimize your practice sessions for exercises across multiple projects. Built with ReScript, Next.js, and AWS serverless technologies.

[Overview](#overview) • [Features](#features) • [Prerequisites](#prerequisites) • [Getting Started](#getting-started) • [Development](#development) • [Deployment](#deployment) • [Architecture](#architecture)

## Overview

Practice Tool is a Progressive Web App (PWA) that enables you to organize exercises into projects, configure practice sessions, and maintain a comprehensive practice history. The application uses a sophisticated algorithm to prioritize exercises based on tempo (slow/fast) and recency, ensuring you focus on what needs the most attention.

Whether you're practicing musical instruments, language learning, physical exercises, or any skill that requires structured repetition, Practice Tool helps you stay organized and track your progress over time.

## Features

- **Project Management**: Organize exercises into projects with configurable tempo settings (slow/fast) for each exercise
- **Smart Practice Sessions**: Generate practice sessions with a specified number of exercises, automatically prioritizing based on:
  - Top priority flag
  - Time since last practice
  - Tempo variation (alternating between slow and fast)
- **Practice History**: Track all completed sessions with detailed exercise-level data
- **Offline Support**: Works offline as a Progressive Web App with service worker caching
- **Multi-language Support**: Built-in internationalization using React Intl
- **Responsive Design**: Optimized for both desktop and mobile with Material-UI components
- **Secure Authentication**: AWS Cognito integration for user authentication and authorization

## Prerequisites

- **Node.js**: Version 20 or higher ([download](https://nodejs.org/))
- **Yarn**: Version 4.10.3 (configured via packageManager in package.json)
- **AWS Account**: Required for deployment ([create free account](https://aws.amazon.com/free/))
- **AWS CLI**: For deployment configuration ([installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **Serverless Framework**: For Lambda deployment ([documentation](https://www.serverless.com/framework/docs))

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/DrMorbid/practice-tool-rescript.git
cd practice-tool-rescript
```

### Install Dependencies

The project uses Yarn workspaces with separate dependencies for frontend and backend:

```bash
# Install frontend dependencies
cd frontend
yarn install

# Install lambda dependencies
cd ../lambdas
yarn install
```

### Environment Configuration

#### Frontend Configuration

Create environment files in the `frontend/` directory:

**.env.development.local** (for local development):
```env
NEXT_PUBLIC_COGNITO_USER_POOL_ID=your-user-pool-id
NEXT_PUBLIC_COGNITO_USER_POOL_CLIENT_ID=your-client-id
NEXT_PUBLIC_COGNITO_URL=https://cognito-idp.your-region.amazonaws.com
NEXT_PUBLIC_COGNITO_REDIRECT_URL=http://localhost:3000/signIn/redirect/
NEXT_PUBLIC_BACK_END_URL=your-api-gateway-url
```

> [!NOTE]
> You'll need to set up AWS Cognito User Pool and obtain the required credentials. Update the `serverless.yml` configuration with your AWS account details.

### Build ReScript Code

Both frontend and lambdas use ReScript and need to be compiled:

```bash
# Build frontend ReScript code
cd frontend
yarn res:build

# Build lambda ReScript code
cd ../lambdas
yarn res:build
```

## Development

### Frontend Development

The frontend is built with Next.js and can be run in development mode:

```bash
cd frontend

# Watch ReScript files for changes (run in separate terminal)
yarn res:dev

# Start Next.js development server
yarn dev
```

The application will be available at `http://localhost:3000`.

### Lambda Development

For local lambda development and testing:

```bash
cd lambdas

# Watch ReScript files for changes
yarn res:dev

# Run tests
yarn test

# Run tests in watch mode
yarn test:watch
```

### Internationalization

To extract translation strings:

```bash
cd frontend
yarn intl
```

This extracts all messages defined with `@intl.description` annotations into locale files.

## Deployment

### Backend (Lambdas)

The backend uses Serverless Framework for deployment to AWS:

```bash
cd lambdas

# Deploy to development stage
yarn deploy:dev

# Deploy to production stage
yarn deploy:prod
```

This will:
- Deploy Lambda functions for project and session management
- Create DynamoDB tables for projects and history
- Configure API Gateway with AWS Cognito authorization
- Set up CORS for allowed origins

### Frontend

The frontend deployment process includes building and uploading to AWS:

```bash
cd frontend

# Complete deployment to development
yarn deploy:complete:dev

# Complete deployment to production
yarn deploy:complete:prod
```

This runs the full pipeline:
1. Compile ReScript code
2. Extract internationalization messages
3. Prepare environment-specific configuration
4. Build Next.js application
5. Deploy to AWS (S3 + CloudFront)

## Architecture

### Technology Stack

**Frontend:**
- [ReScript](https://rescript-lang.org/) - Type-safe functional language that compiles to JavaScript
- [Next.js 15](https://nextjs.org/) - React framework with App Router
- [Material-UI v6](https://mui.com/) - React component library
- [React Hook Form](https://react-hook-form.com/) - Form validation
- [React Intl](https://formatjs.io/docs/react-intl/) - Internationalization
- [Serwist](https://serwist.pages.dev/) - Service worker for PWA functionality
- [React OIDC Context](https://github.com/authts/react-oidc-context) - Authentication

**Backend:**
- [AWS Lambda](https://aws.amazon.com/lambda/) - Serverless compute
- [AWS DynamoDB](https://aws.amazon.com/dynamodb/) - NoSQL database
- [AWS API Gateway](https://aws.amazon.com/api-gateway/) - HTTP API
- [AWS Cognito](https://aws.amazon.com/cognito/) - User authentication
- [Serverless Framework v4](https://www.serverless.com/) - Infrastructure as code

**Development:**
- [ReScript PPX Spice](https://github.com/green-labs/ppx-spice) - JSON serialization
- [ReScript Jest](https://github.com/glennsl/rescript-jest) - Testing framework
- Node.js 20.x runtime

### Project Structure

```
practice-tool-rescript/
├── frontend/                 # Next.js frontend application
│   ├── app/                 # Next.js App Router pages
│   ├── src/                 # ReScript source code
│   │   ├── common/          # Shared utilities and types
│   │   ├── exercise/        # Exercise management
│   │   ├── history/         # Practice history
│   │   ├── home/            # Home page
│   │   ├── i18n/            # Internationalization
│   │   ├── menu/            # Navigation components
│   │   ├── project/         # Project management
│   │   ├── session/         # Practice session logic
│   │   └── store/           # Application state
│   ├── public/              # Static assets
│   └── script/              # Build and deployment scripts
├── lambdas/                 # AWS Lambda functions
│   ├── src/                 # ReScript source code
│   │   ├── bindings/        # AWS SDK bindings
│   │   ├── common/          # Shared utilities
│   │   ├── exercise/        # Exercise types and utilities
│   │   ├── history/         # History Lambda handlers
│   │   ├── project/         # Project Lambda handlers
│   │   └── session/         # Session Lambda handlers
│   ├── test/                # Jest tests
│   └── serverless.yml       # Serverless Framework configuration
└── README.md
```

### Data Model

**Projects:**
- Store exercises with configurable tempo settings
- Each exercise has slow/fast tempo values and priority flags
- Track last practiced date and tempo for each exercise

**Sessions:**
- Generate practice sessions from one or multiple projects
- Algorithm prioritizes exercises based on recency and tempo
- Support for top-priority exercises

**History:**
- Record all completed practice sessions
- Store exercise-level details including tempo practiced
- Query by user and date range

## Resources

- [ReScript Documentation](https://rescript-lang.org/docs/manual/latest/introduction)
- [Next.js Documentation](https://nextjs.org/docs)
- [AWS Serverless Application Lens](https://docs.aws.amazon.com/wellarchitected/latest/serverless-applications-lens/welcome.html)
- [Serverless Framework Documentation](https://www.serverless.com/framework/docs)
- [Material-UI Documentation](https://mui.com/material-ui/getting-started/)

## Troubleshooting

### ReScript Compilation Errors

If you encounter ReScript compilation errors:

```bash
# Clean and rebuild
yarn res:build

# Or for watch mode
yarn res:dev
```

### Lambda Deployment Issues

If Serverless deployment fails:

1. Verify AWS credentials are configured: `aws configure`
2. Check the `serverless.yml` configuration matches your AWS account
3. Ensure DynamoDB table names don't conflict with existing tables

### Frontend Build Issues

If the Next.js build fails:

1. Ensure all ReScript code is compiled: `yarn res:build`
2. Clear Next.js cache: `rm -rf .next`
3. Verify environment variables are set correctly

### Authentication Issues

If authentication fails:

1. Verify Cognito configuration in `serverless.yml`
2. Check redirect URLs match in both Cognito and environment variables
3. Ensure the API Gateway authorizer is correctly configured
