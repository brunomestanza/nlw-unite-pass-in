# Each FROM is an stage on the process, the first one is for the pnpm installation
FROM node:20 AS base

# Install pnpm on the node image
RUN npm install -g pnpm

# Using the previous stage, we install all the dependencies
FROM base AS dependencies

# When we enter in an operational system, we can define an WORKDIR, if don't defined,
# it will use the root directory on the OS, not recommended
WORKDIR /usr/src/app

# Copy the package.json and the pnpm-lock.yaml to the ./ folder on the WORKDIR above
COPY package.json pnpm-lock.yaml ./

# Install all the dependencies
RUN pnpm install

# Using the first stage, we build the app
FROM base as build

# Set the same WORKDIR again
WORKDIR /usr/src/app

# Copy all files in the WORKDIR, except the ones in the .dockerignore file
# It should have all the necessary files to run the application
COPY . .

# Copy the node_modules created in the previous step, this way we can ensure that
# the node_modules folder is up to date
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

# Run the build
RUN pnpm build

# Remove all the devDependencies specified in the package.json
RUN pnpm prune --prod

# Here we use another docker image to run the last step because this docker image
# is smaller the the other one
FROM node:20-alpine3.19 AS deploy

# Define the same workspace
WORKDIR /usr/src/app

# Install the pnpm again and the prisma
RUN npm i -g pnpm prisma

# Copy the aplication build and all files to deploy it
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/prisma ./prisma

# We can pass an env variable here, but isn't the best pratice
# ENV DATABASE_URL="file:./db.sqlite"
# ENV API_BASE_URL="http://localhost:3333"

# Run all the migrations on Prisma orm
RUN pnpm prisma generate

# Expose the port the application will listen to
EXPOSE 3333

# Run the start command in the terminal
CMD ["pnpm", "start"]