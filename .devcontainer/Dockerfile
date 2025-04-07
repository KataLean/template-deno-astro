ARG ARCH="arm64"
ARG DEBIAN_VERSION="stable"
#ARG DENO_VERSION="2.2.8"

##
# DEVELOPMENT
##

#FROM --platform=${ARCH} denoland/deno:${DENO_VERSION} AS development 
FROM --platform=${ARCH} debian:${DEBIAN_VERSION} AS development 

ARG DEBIAN_PACKAGES="curl unzip ca-certificates vim tree" \
  DIRECTORY="/app" \
  USER="deno" \
  DENO_INSTALL="/usr/local" \
  DENO_INSTALL_ROOT="/usr/local/bin"

WORKDIR ${DIRECTORY}

## Tell Docker what port we are going to listen on
EXPOSE 3001

## Install Debian packages
ENV DEBIAN_FRONTEND="noninteractive" \
  INITRD="No" \
  DEBIAN_PACKAGES=$DEBIAN_PACKAGES \
  DENO_INSTALL=$DENO_INSTALL \
  DENO_INSTALL_ROOT=$DENO_INSTALL_ROOT
RUN echo "*** Installing locales ${DEBIAN_PACKAGES}" && \
  apt-get update -qq && \
  apt-get install -y -qq --no-install-recommends locales ${DEBIAN_PACKAGES} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  cd /usr/local && \
  curl -sSL https://dl.dagger.io/dagger/install.sh | sh -

## Manage en_US.UTF-8 locales
RUN locale-gen en_US.UTF-8 && \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
  locale-gen

## Add the non-root user
RUN useradd --uid 1982 --create-home --shell /bin/bash --user-group ${USER}

## Use a non-root user in the image
#USER ${USER}

## Copy de config bash script
COPY .devcontainer/config_init.sh /usr/local/bin/config_init.sh

## Install Deno 2 and pnpm
RUN curl -sSL https://deno.land/install.sh | sh -s -- --yes && \
  deno install --global -A --root ${DENO_INSTALL} npm:astro@latest && \
  #deno install --global -A --root ${DENO_INSTALL} npm:pnpm@latest && \
  astro telemetry disable

## Using --entrypoint caches the dependencies as a vendored layer
#COPY --chown=${USER}:${USER} main.ts .
COPY main.ts .
RUN deno install --entrypoint main.ts

## Bundle app source
#RUN chown -R ${USER}:${USER} ${DIRECTORY}
#COPY --chown=${USER}:${USER} . .
COPY . .

# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno task install && \
  deno task astro:build && \
  deno cache main.ts

## We need to run the application in the background
# CMD ["deno", "run", "-A", "main.ts"]
CMD [ "sleep", "infinity" ]



##
# BUILD
##

## To build this image, run the following command:
## docker build -t deno-build-app:latest -f .devcontainer/Dockerfile --target builder .
FROM debian:stable AS builder

ARG DEBIAN_PACKAGES="curl" \
  DIRECTORY="/app" \
  USER="deno" \
  DENO_INSTALL="/usr/local" \
  DENO_INSTALL_ROOT="/usr/local/bin"

WORKDIR ${DIRECTORY}

## Install Debian packages
ENV DEBIAN_FRONTEND="noninteractive" \
  INITRD="No" \
  DEBIAN_PACKAGES=$DEBIAN_PACKAGES \
  DENO_INSTALL=$DENO_INSTALL \
  DENO_INSTALL_ROOT=$DENO_INSTALL_ROOT
RUN echo "*** Installing ${DEBIAN_PACKAGES}" && \
  apt-get update -qq && \
  apt-get install -y -qq --no-install-recommends ${DEBIAN_PACKAGES} && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

## Install Deno 2 along with pnpm and Astro
RUN curl -sSL https://deno.land/install.sh | sh -s -- --yes && \
  deno install --global -A --root ${DENO_INSTALL} npm:astro@latest && \
  #deno install --global -A --root ${DENO_INSTALL} npm:pnpm@latest && \
  astro telemetry disable

## Add the non-root user
RUN useradd --uid 1982 --create-home --shell /sbin/nologin --user-group ${USER} && \
  chown -R ${USER}:${USER} ${DIRECTORY}

## Copy local code to the container image
COPY --chown=${USER}:${USER} . .

## Use the non-root user in the image
USER ${USER}

## Install and build the main app
RUN deno install --entrypoint main.ts

## Compile the main app
## https://docs.deno.com/runtime/reference/cli/compile/#compile-options-target
RUN deno compile -A --output ${DENO_INSTALL_ROOT}/main_macos_arm64 --target aarch64-apple-darwin --include assets main.ts && \
  deno compile -A --output ${DENO_INSTALL_ROOT}/main_windows_x86_64.exe --target x86_64-pc-windows-msvc --include assets main.ts && \
  deno compile -A --output ${DENO_INSTALL_ROOT}/main_linux_x86_64 --target x86_64-unknown-linux-gnu --include assets main.ts && \
  deno compile -A --output ${DENO_INSTALL_ROOT}/main_linux_arm64 --target aarch64-unknown-linux-gnu --include assets main.ts

## Please note that MacOS binaries need to be signed afterwards
# codesign -s "Developer ID Application: Arno B." main_macos_arm64

## Also note that Windows binaries can also be signed
# signtool sign /fd SHA256 main_windows_x86_64.exe


##
# PRODUCTION
##

## Prepare the production ready image
## To build this image, run the following command:
## docker build --platform linux/arm64 -t deno-build-app:latest -f .devcontainer/Dockerfile --target production .
FROM debian:stable-slim AS production

ARG DEBIAN_PACKAGES="curl unzip ca-certificates vim tree" \
  DIRECTORY="/app" \
  USER="deno" \
  DENO_INSTALL_ROOT="/usr/local/bin"

WORKDIR ${DIRECTORY}

## Tell Docker what port we are going to listen on
EXPOSE 3000

## Export environment variables
ENV DIRECTORY=${DIRECTORY} \
  DENO_INSTALL_ROOT=$DENO_INSTALL_ROOT

## Add the non-root user
RUN useradd --uid 1982 --create-home --shell /sbin/nologin --user-group ${USER} && \
  chown -R ${USER}:${USER} ${DIRECTORY}

## Install the compiled Deno application
COPY --chown=${USER}:${USER} --from=builder ${DENO_INSTALL_ROOT}/main_linux_arm64 ${DENO_INSTALL_ROOT}/main

## Let's run our application, using the production build
ENTRYPOINT [ "main" ]
