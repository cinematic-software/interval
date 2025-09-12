1. `pnpm install`
2. Bump version in `package.json` to new version number
3. `pnpm build` compiles + type checks
4. `pnpm run pkg` creates a "release" folder w/ the contents of the npm package
5. `./scripts/pub.sh` publishes to npm registry. Note! This isn't a `pnpm` command like the others because npm doesn't think you're logged in when running from the pnpm script runner.
6. `pnpm docker` creates a Docker image + publishes to the Docker registry
