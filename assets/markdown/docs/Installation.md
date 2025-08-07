# Installation Guide for Sherkety App

This guide covers setting up the Sherkety App on your local machine, including installing dependencies, configuring Firebase, and using Nx plugins for streamlined workflows.

## Prerequisites

1. **Flutter SDK**: Ensure that Flutter is installed and up to date.
2. **NX.dev**: Set up for managing the monorepo structure.
3. **Firebase**: A Firebase project is required with configuration files.

## Step-by-Step Installation

1. **Clone the Repository**

   ```bash
   git clone [repository-url]
   cd sherkety-flutter

   ```

2. **Nx Plugins and Code Generators**

```bash
# Install nx.dev globally

npm install -g nx

# Run NPM Install

npm install --force

# Generate Translation Files

npx nx run core:gen-l10n
cd libs
cd core
flutter gen-l10n

# Update Libraries in Core Project

npx nx run core:get

# Update Libraries in Store Project

npx nx run store:get

# Update Libraries in UI Library Project

npx nx run ui-library:get

# Update Libraries in Sherkety App Project

npx nx run sherkety-app:get

# Generate an Angular Library (example for web essentials)

nx generate @nrwl/angular:library --name=assets --directory=libs/web/essentials --style=scss --standalone=false --buildable --publishable --importPath=@sherkety-web/assets

# Run the Flutter Project

cd apps
cd sherkety-app
flutter run

# If running for the first time, clean and fetch packages

flutter clean
flutter pub get

# Alternatively, run the Flutter Project using Nx

npx nx run sherkety-app:run

# Run the Web Project

npx nx serve sherkety-web
```

3. **Cleaning Data**

```bash
# Clean Core Project

npx nx run core:clean

# Clean Store Project

npx nx run store:clean

# Clean UI Library Project

npx nx run ui-library:clean

# Clean Sherkety App Project

npx nx run sherkety-app:clean
```

## Set up CI!

Nx comes with local caching already built-in (check your `nx.json`). On CI you might want to go a step further.

- [Set up remote caching](https://nx.dev/features/share-your-cache)
- [Set up task distribution across multiple machines](https://nx.dev/nx-cloud/features/distribute-task-execution)
- [Learn more how to setup CI](https://nx.dev/recipes/ci)

## Explore the project graph

Run `npx nx graph` to show the graph of the workspace.
It will show tasks that you can run with Nx.

- [Learn more about Exploring the Project Graph](https://nx.dev/core-features/explore-graph)

## Connect with us!

- [Join the community](https://nx.dev/community)
- [Subscribe to the Nx Youtube Channel](https://www.youtube.com/@nxdevtools)
- [Follow us on Twitter](https://twitter.com/nxdevtools)
