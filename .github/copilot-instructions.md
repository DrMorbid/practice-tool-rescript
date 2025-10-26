# GitHub Copilot Instructions

## Priority Guidelines

When generating code for this repository:

1. **Version Compatibility**: Always detect and respect the exact versions of languages, frameworks, and libraries used in this project
2. **Context Files**: Prioritize patterns and standards defined in the `.github/copilot` directory
3. **Codebase Patterns**: When context files don't provide specific guidance, scan the codebase for established patterns
4. **Architectural Consistency**: Maintain the serverless microservices architectural style and established boundaries
5. **Code Quality**: Prioritize maintainability, testability, and type safety in all generated code

## Technology Version Detection

Before generating code, scan the codebase to identify:

1. **Language Versions**:
   - **ReScript**: Version 11.1.4 (primary language)
   - **TypeScript**: Version 5.9.3 (for Next.js integration and type definitions)
   - **JavaScript**: ES5 target for browser compatibility, ESNext modules for development
   - **Node.js**: Version 20.x runtime (AWS Lambda and development)
   - Never use language features beyond the detected versions

2. **Framework Versions**:
   - **Next.js**: Version 15.5.6 with App Router (not Pages Router)
   - **React**: Version 19.2.0
   - **Material-UI (MUI)**: Version 6.1.8
   - **ReScript Core**: Version 1.6.1 (always open with `-open RescriptCore` flag)
   - **Serverless Framework**: Version 4.21.1
   - Never suggest features not available in these specific versions

3. **Library Versions**:
   - **Frontend/Lambda Libraries**:
     - `@greenlabs/ppx-spice`: 0.2.2 (JSON serialization with `@spice` decorator)
     - `@rescript/react`: 0.14.0 (JSX version 4)
     - `@rescript-mui/material`: 5.1.2
     - `rescript-react-intl`: 3.0.0
     - `react-oidc-context`: 3.3.0
     - `@aws-sdk/client-dynamodb`: 3.911.0
     - `@aws-sdk/lib-dynamodb`: 3.911.0
     - `jest`: 30.2.0 (for lambda tests)
   - **MCP Server Libraries**:
     - `spring-ai-starter-mcp-server`: 1.0.3
     - `spring-boot`: 3.5.7
     - `junit-platform-launcher`: (test runtime)
   - Generate code compatible with these specific versions

## Project Structure

This is a monorepo with three main workspaces:

### Frontend (`/frontend`)
- **Next.js 15** application with App Router
- **ReScript** source code in `src/` directory, compiles to `.res.js` files
- **TypeScript** for Next.js integration in `app/` directory
- **Module system**: ES modules (`"module": "esmodule"` in rescript.json)
- **Client components**: Use `@@directive("'use client';")` at the top of React components
- **In-source compilation**: ReScript compiles to `.res.js` files alongside `.res` files

### Lambdas (`/lambdas`)
- **AWS Lambda** handlers written in ReScript
- **Module system**: CommonJS (`"module": "commonjs"` in rescript.json)
- **Serverless Framework** for deployment configuration
- **DynamoDB** for data persistence
- **Jest** for unit testing

### MCP Server (`/mcp-server`)
- **Spring Boot 3.5.7** application providing Model Context Protocol server
- **Java 25** with Gradle build system
- **Spring AI 1.0.3** for MCP server capabilities
- **JUnit 5** for testing
- **Package structure**: `click.practice_tool.practice_tool`

### Shared Patterns Across Frontend and Lambdas
- ReScript compiled with `-open RescriptCore` flag (RescriptCore module is always open)
- PPX Spice for JSON serialization with `-uncurried` flag
- JSX version 4 for React components

## ReScript Coding Standards

### General Principles
- **Type Safety First**: Leverage ReScript's type system to prevent runtime errors
- **Immutability**: All data structures are immutable by default
- **Pattern Matching**: Use pattern matching with `switch` for exhaustive case handling
- **Pipe Operator**: Use pipe-first (`->`) for method chaining and data transformation
- **Option Type**: Use `option<'a>` instead of nullable values; use `Option.map`, `Option.getOr`, etc.

### Naming Conventions

1. **Modules**: PascalCase with underscores separating logical sections
   - Pattern: `{Feature}_{Subfeature}_{Type}.res`
   - Examples: `Project_Type.res`, `Exercise_Constant.res`, `History_Lambda_Get.res`
   - Submodules within files: PascalCase (e.g., `module FromRequest`, `module DBItem`)

2. **Types**: camelCase for type names
   - Main type in a module: `type t`
   - Additional types: descriptive camelCase (e.g., `type tempo`, `type lastPracticed`)
   - Request/response types: include context (e.g., `type projectForRequest`, `type historyRequest`)

3. **Functions**: camelCase
   - Examples: `createSession`, `toHistoryResponse`, `fromRequest`

4. **React Components**: 
   - File names: PascalCase with underscores (e.g., `Home_Page.res`, `Session_Create_Page.res`)
   - Component function: `make` (standard ReScript React convention)
   - Export as default in Next.js pages: `let default = () => <Component />`

5. **Constants and Variables**: camelCase
   - Examples: `let menuRef`, `let isMdUp`, `let bottomBarHeight`

6. **Bindings**: Match external library conventions
   - Examples: `@module("react-oidc-context") external useAuth: unit => Auth.t = "useAuth"`

### Type Annotations

1. **PPX Spice Decorators**: Use `@spice` for JSON serialization
   ```rescript
   @spice
   type t = {
     name: string,
     active: bool,
   }
   ```

2. **Codec Customization**: Use `@spice.codec` for custom type conversion
   ```rescript
   @spice
   type t = {
     date: @spice.codec(Util.Date.SpiceCodec.date) Date.t,
     tempo: tempo,
   }
   ```

3. **Enum Variants**: Use `@spice.as` for string representation
   ```rescript
   @spice
   type tempo = 
     | @spice.as("SLOW") Slow 
     | @spice.as("FAST") Fast
   ```

4. **Optional Fields**: Use `?` suffix for optional record fields
   ```rescript
   type t = {
     name: string,
     lastPracticed?: lastPracticed,
   }
   ```

5. **External Bindings**: Use specific decorators
   ```rescript
   @send external removeUser: (t, unit) => unit = "removeUser"
   @module("react-oidc-context") external useAuth: unit => Auth.t = "useAuth"
   @as("access_token") accessToken: string
   ```

### Module Organization

1. **Type Definitions First**: Define types at the top of the module
2. **Submodules for Variants**: Group related functionality in submodules
   ```rescript
   module FromRequest = {
     @spice
     type t = { /* fields */ }
   }
   ```
3. **Module Functors**: Use for reusable patterns (e.g., `MakeBodyExtractor`, `DBSaver`)
4. **Open Statements**: Place at the top after type definitions
   ```rescript
   open Util.Lambda
   open AWS.Lambda
   ```

### Pattern Matching

1. **Exhaustive Matching**: Always handle all cases in `switch` statements
2. **Result Type Handling**:
   ```rescript
   switch result {
   | Ok(value) => // handle success
   | Error(error) => // handle error
   }
   ```
3. **Option Type Handling**:
   ```rescript
   switch value {
   | Some(v) => // use v
   | None => // handle absence
   }
   ```
4. **Pipe with Pattern Match**:
   ```rescript
   result
   ->Result.map(value => /* transform */)
   ->Result.flatMap(value => /* chain */)
   ```

### React Component Patterns

1. **Component Definition**:
   ```rescript
   @react.component
   let make = (~prop1, ~prop2=?, ~children) => {
     // component body
   }
   ```

2. **Client Directive**: Use for Next.js client components
   ```rescript
   @@directive("'use client';")
   
   @react.component
   let make = () => {
     // component body
   }
   ```

3. **Hooks Usage**:
   ```rescript
   let value = React.useState(() => initialValue)
   let router = Next.Navigation.useRouter()
   let intl = ReactIntl.useIntl()
   let auth = ReactOidcContext.useAuth()
   ```

4. **Effects**:
   ```rescript
   React.useEffect(() => {
     // effect logic
     None  // cleanup function or None
   }, (dependency1, dependency2))
   ```

5. **Refs**:
   ```rescript
   let menuRef = React.useRef(Nullable.null)
   ```

6. **Conditional Rendering**:
   ```rescript
   {condition ? <Component /> : Jsx.null}
   ```

7. **MUI Component Usage**:
   ```rescript
   <Mui.Button variant={Contained} size={Large} onClick=handler>
     {intl->ReactIntl.Intl.formatMessage(Message.id)->Jsx.string}
   </Mui.Button>
   ```

### Lambda Handler Patterns

1. **Handler Type Signature**:
   ```rescript
   let handler: AWS.Lambda.handler<'a, 'b> = async event =>
   ```

2. **Module Functors for Common Patterns**:
   ```rescript
   module SaveProjectBody = {
     type t = Project_Type.FromRequest.t
     let decode = Project_Type.FromRequest.t_decode
   }
   module Body = MakeBodyExtractor(SaveProjectBody)
   ```

3. **Result Chaining**:
   ```rescript
   switch event
   ->getUser
   ->Result.flatMap(userId => 
     event->Body.extract->Result.flatMap(Project_Util.fromRequest(_, ~userId))
   )
   ->Result.map(async project => {
     await project->DBSaver.save
   }) {
   | Ok(result) => await result
   | Error(result) => result
   }
   ```

4. **Async Operations**:
   ```rescript
   let (result1, result2) = await (
     operation1(),
     operation2(),
   )->Promise.all2
   ```

### Error Handling

1. **Result Type**: Use `Result.t<'a, 'b>` for operations that can fail
2. **Option Type**: Use `option<'a>` for values that may be absent
3. **Lambda Responses**: Return proper HTTP status codes
   ```rescript
   {
     statusCode: 200,
     body: response->encode->JSON.stringify,
   }
   ```

### Testing Patterns

1. **Jest Test Structure**:
   ```rescript
   open Jest
   open Expect
   
   describe("Feature Name", () => {
     describe("Subfeature", () => {
       test("Given X, when Y, then Z", () => {
         expect(actualValue)->toEqual(expectedValue)
       })
     })
   })
   ```

2. **Given-When-Then Format**: Use descriptive test names
3. **Test File Naming**: `{Feature}_{Subfeature}_test.res`
4. **Test Location**: Mirror source structure in `test/` directory

## Material-UI (MUI) Patterns

### Component Styling

1. **Sx Prop**: Use MUI's sx prop for styling
   ```rescript
   module Classes = {
     let container = (~bottomBarHeight=?, isMdUp) => {
       let styles = [
         Mui.Sx.Array.obj({
           marginLeft: String(`${value}px`),
         }),
       ]
       styles->Mui.Sx.array
     }
   }
   ```

2. **Theme Access**:
   ```rescript
   Mui.Sx.Array.func(theme => 
     Mui.Sx.Array.obj({
       paddingTop: String(theme->MuiSpacingFix.spacing(3))
     })
   )
   ```

3. **Responsive Design**:
   ```rescript
   let isMdUp = Mui.Core.useMediaQueryString(App_Theme.Breakpoint.mdUp)
   ```

4. **Style Composition**: Combine style arrays
   ```rescript
   styles1
   ->Array.concat(styles2)
   ->Array.concat(conditionalStyles)
   ->Mui.Sx.array
   ```

### Theme Configuration

1. **Theme Creation**: Use `Mui.ThemeOptions.create` with palette and typography
2. **Dark Mode Support**: Check `prefersDarkMode` media query
3. **Custom Colors**: Define in `App_Theme_Colors` module
4. **Breakpoints**: Define in `App_Theme.Breakpoint` module

## Internationalization

### Message Definition

1. **Message IDs**: Use hierarchical structure
   ```rescript
   module Home = {
     @intl.description("Welcome message on home page")
     let welcome = "home.welcome"
     
     @intl.description("Sign in button text")
     let signIn = "home.signIn"
   }
   ```

2. **Message Usage**:
   ```rescript
   let intl = ReactIntl.useIntl()
   {intl->ReactIntl.Intl.formatMessage(Message.Home.welcome)->Jsx.string}
   ```

3. **Locale Management**: Store in global state using Restorative store

## State Management

### Restorative Store

1. **Store Definition**:
   ```rescript
   let {useStoreWithSelector, dispatch} = createStore(
     State.initialState, 
     (state, action: Action.action) => 
       switch action {
       | StoreLocale(locale) => {...state, locale}
       | StoreMenuItemIndex(menuItemIndex) => {...state, menuItemIndex}
       }
   )
   ```

2. **Selector Usage**:
   ```rescript
   let locale = Store.useStoreWithSelector(({locale}) => locale)
   let bottomBarHeight = Store.useStoreWithSelector(({?bottomBarHeight}) => bottomBarHeight)
   ```

3. **Dispatching Actions**:
   ```rescript
   Store.dispatch(StoreLocale(newLocale))
   Store.dispatch(ResetBottomBarHeight)
   ```

## AWS Integration

### DynamoDB Patterns

1. **Item Types**: Define with `@spice` for automatic JSON codec generation
2. **Query Operations**: Use module functors for consistency
   ```rescript
   module DBQuery = {
     type t = t
     let decode = t_decode
     let tableName = Global.EnvVar.tableNameHistory
   }
   module DBQueryCaller = Util.DynamoDB.DBQueryCaller(DBQuery)
   ```

3. **Key Schema**:
   - Hash key: `userId` (string)
   - Range key: `name` (projects) or `date` (history)

### Lambda Configuration

1. **Runtime**: Node.js 20.x
2. **Module System**: CommonJS for Lambda compatibility
3. **Handler Exports**: Use CommonJS exports in `index.js`
   ```javascript
   const handler = require('./src/Module.res.js');
   exports.handlerName = handler.handler;
   ```

### Authentication

1. **Cognito Integration**: Use `react-oidc-context` for frontend
2. **JWT Authorization**: API Gateway validates tokens
3. **User ID Extraction**: Extract from JWT claims in Lambda event context

## Build and Deployment

### ReScript Compilation

1. **Frontend**: ES modules with in-source compilation
   - `yarn res:build` - Full build
   - `yarn res:dev` - Watch mode

2. **Lambdas**: CommonJS with in-source compilation
   - `yarn res:build` - Full build
   - `yarn res:dev` - Watch mode

### Next.js Configuration

1. **Output**: Static export (`output: "export"`)
2. **Service Worker**: Serwist integration for PWA
3. **Trailing Slash**: Enabled for static hosting
4. **React Strict Mode**: Enabled

### Serverless Deployment

1. **Stages**: `dev` and `prod`
2. **Region**: `eu-central-1`
3. **CORS**: Configure allowed origins per stage
4. **IAM Permissions**: Minimal permissions for DynamoDB operations

## Code Quality Standards

### Maintainability
- Write self-documenting code with clear type definitions
- Use meaningful names that reflect purpose
- Keep functions focused on single responsibilities
- Leverage ReScript's type system to make invalid states unrepresentable
- Group related functionality in submodules

### Performance
- Use immutable data structures (built-in to ReScript)
- Leverage async/await for concurrent operations with `Promise.all2`
- Minimize re-renders in React by using proper dependencies in hooks
- Use MUI's sx prop for optimal styling performance
- Cache expensive computations when appropriate

### Security
- Never expose sensitive credentials in code
- Use environment variables for configuration
- Validate all inputs from external sources
- Use Cognito for authentication and authorization
- Implement proper CORS configuration
- Use parameterized queries via AWS SDK (prevents injection)

### Testability
- Write pure functions whenever possible
- Use dependency injection through module functors
- Separate business logic from I/O operations
- Write descriptive test names using Given-When-Then format
- Test edge cases and error conditions

## Documentation Requirements

- Use `@intl.description` annotations for all internationalization messages
- Document complex type definitions with comments when the purpose isn't obvious
- Add comments for non-obvious business logic
- Keep README.md updated with architectural changes
- Document environment variables in README

## Technology-Specific Guidelines

### ReScript Guidelines
- Use ReScript 11.1.4 features only
- Always use `-open RescriptCore` (configured globally)
- Use JSX version 4 for React components
- Compile with PPX Spice for JSON serialization
- Use `@spice` decorator for all serializable types
- Use pipe-first operator (`->`) for chaining
- Prefer pattern matching over imperative conditionals
- Use `Result.t` for operations that can fail
- Use `option<'a>` for optional values, never nullable types

### Next.js 15 Guidelines
- Use App Router (not Pages Router)
- Place pages in `app/` directory as TypeScript files
- Use `@@directive("'use client';")` for client components in ReScript
- Export default components from page files
- Use Next.js navigation hooks: `Next.Navigation.useRouter()`
- Configure for static export
- Integrate Serwist for service worker

### React 19 Guidelines
- Use function components exclusively
- Use hooks for state and side effects
- Keep effects minimal and focused
- Return `None` from useEffect for no cleanup
- Use `Jsx.null` for no render
- Use `Jsx.string` to render strings
- Use `ReactDOM.Ref.domRef` for DOM refs

### TypeScript Guidelines
- Use TypeScript 5.9.3 features only
- Target ES5 for broad compatibility
- Enable strict mode
- Use for Next.js integration and type definitions
- Don't mix TypeScript and ReScript in the same source files
- Use `.d.ts` files for type declarations

### AWS Lambda Guidelines
- Use Node.js 20.x runtime
- Keep handler functions async
- Return proper HTTP response shape with statusCode and body
- Extract user from JWT in request context
- Use Result type for error handling
- Use module functors for consistent patterns
- Keep functions small and focused

### DynamoDB Guidelines
- Use composite keys (hash + range) for efficient queries
- Store dates as ISO strings for range queries
- Use consistent attribute naming
- Leverage conditional expressions for atomic operations
- Use Query operation with userId hash key
- Use additional conditions for range key filtering

### Jest Guidelines
- Use Jest 30.2.0 features
- Place tests in `test/` directory mirroring source structure
- Name test files with `_test.res` suffix
- Use Given-When-Then test naming
- Group tests with `describe` blocks
- Use `expect` for assertions
- Test business logic in isolation

### Java/Spring Boot Guidelines (MCP Server)
- Use Java 25 features
- Follow Spring Boot 3.5.7 conventions
- Use `@SpringBootApplication` for main application class
- Use JUnit 5 (`org.junit.jupiter.api.Test`) for testing
- Use `@SpringBootTest` for integration tests
- Package structure: `click.practice_tool.practice_tool`
- Build with Gradle (not Maven)
- Follow Spring AI 1.0.3 patterns for MCP server implementation
- Keep application configuration in `src/main/resources/application.properties`

### Gradle Guidelines (MCP Server)
- Use Gradle 8.x with Kotlin DSL or Groovy DSL
- Configure Java toolchain for version 25
- Use Spring Boot Gradle plugin 3.5.7
- Use Spring dependency management plugin 1.1.7
- Declare Spring AI BOM for version management
- Configure JUnit Platform for testing with `useJUnitPlatform()`
- Standard directory structure: `src/main/java`, `src/main/resources`, `src/test/java`

## Version Control Guidelines

- Follow Semantic Versioning for releases
- Write clear, descriptive commit messages
- Keep commits focused on single changes
- Update README.md for significant changes
- Document breaking changes clearly

## General Best Practices

- **Type Safety**: Let the type system prevent errors at compile time
- **Immutability**: Never mutate data; create new values instead
- **Pure Functions**: Prefer pure functions over side effects
- **Composition**: Build complex functionality from simple, reusable pieces
- **Error Handling**: Always handle Result and Option types explicitly
- **Naming**: Use descriptive names that convey purpose and context
- **Module Organization**: Group related functionality logically
- **Testing**: Write tests for business logic and edge cases
- **Documentation**: Keep code self-documenting; add comments only when necessary
- **Consistency**: Follow established patterns from existing code

## Project-Specific Guidance

### When Creating New Features

1. **Frontend Components**:
   - Create in appropriate feature directory (`src/{feature}/`)
   - Use `{Feature}_{Component}.res` naming
   - Add `@@directive("'use client';")` if using hooks or interactivity
   - Define types in separate `{Feature}_Type.res` file
   - Add internationalization messages in `Message.res`

2. **Lambda Handlers**:
   - Create in appropriate domain directory (`src/{domain}/`)
   - Use `{Domain}_Lambda_{Operation}.res` naming
   - Define types in `{Domain}_Type.res`
   - Use module functors for DynamoDB operations
   - Add tests in `test/{domain}/`
   - Export handler in `index.js`

3. **MCP Server Components**:
   - Create in appropriate package under `click.practice_tool.practice_tool`
   - Follow Spring Boot conventions for package organization
   - Use `@Component`, `@Service`, or `@Controller` annotations as appropriate
   - Implement MCP protocol endpoints using Spring AI annotations
   - Add tests in `src/test/java` mirroring source structure
   - Use constructor injection for dependencies

4. **Shared Utilities**:
   - Place in `common/` directory (frontend/lambdas)
   - Use module functors for reusable patterns
   - Keep utilities pure and testable

### Architectural Boundaries

- **Frontend**: Never directly access AWS services; always use Lambda backend
- **Lambdas**: Keep handlers thin; delegate to utility modules
- **MCP Server**: Provides Model Context Protocol interface for AI integration; does not directly access AWS services
- **Types**: Share type definitions between frontend and backend where appropriate
- **State**: Use Restorative store for global state, local state for component-specific data
- **Authentication**: All API requests must be authenticated via Cognito
- **Data Access**: All DynamoDB access goes through utility functors

### When in Doubt

- Scan similar files in the codebase for established patterns
- Prioritize consistency with existing code over external best practices
- Leverage ReScript's type system to guide implementation
- Use module functors for repeated patterns
- Keep functions small and composable
- Write tests to verify behavior
