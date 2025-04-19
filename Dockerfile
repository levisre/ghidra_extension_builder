# Define some default values
ARG GHIDRA_BIN_DIR=ghidra_9.1.2_PUBLIC

ARG GHIDRA_EXTENSION_REPO_DIR=Ghidra_Extension_dir

#ARG GHIDRA_ROOT_NAME=ghidra_9.1.2_PUBLIC
#ARG GHIDRA_EXTENSION_NAME=Ghidra_Extension

# From version 11.2, JDK should be 21, otherwhise you can choose an older version by changing docker tag. Ref: https://github.com/NationalSecurityAgency/ghidra/issues/6762
# with pior to 11.2, this may jdk17-alpine or jdk11-alpine, depends on Ghidra version
FROM gradle:jdk21-alpine AS builder

ARG GHIDRA_BIN_DIR
#ARG GHIDRA_ROOT_NAME
ARG GHIDRA_EXTENSION_REPO_DIR
#ARG GHIDRA_EXTENSION_NAME

WORKDIR /build

# Copy Ghidra and Ghidra extensions source code to container
COPY $GHIDRA_EXTENSION_REPO_DIR /build/$GHIDRA_EXTENSION_REPO_DIR
COPY $GHIDRA_BIN_DIR /build/$GHIDRA_BIN_DIR

ENV GHIDRA_INSTALL_DIR=/build/$GHIDRA_BIN_DIR

WORKDIR /build/$GHIDRA_EXTENSION_REPO_DIR

# Run gradle Task, exclude the building of test code
RUN gradle -x compileTestJava -x buildHelp

FROM scratch AS export-stage

ARG GHIDRA_EXTENSION_REPO_DIR

COPY --from=builder /build/$GHIDRA_EXTENSION_REPO_DIR/dist ./
