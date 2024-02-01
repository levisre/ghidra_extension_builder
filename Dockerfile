# Define some default values
ARG GHIDRA_BIN_DIR=ghidra_9.1.2_PUBLIC

ARG GHIDRA_EXTENSION_REPO_DIR=Ghidra_Extension_dir

#ARG GHIDRA_ROOT_NAME=ghidra_9.1.2_PUBLIC
#ARG GHIDRA_EXTENSION_NAME=Ghidra_Extension

from gradle:jdk17-alpine as builder

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

from scratch as export-stage

ARG GHIDRA_EXTENSION_REPO_DIR

COPY --from=builder /build/$GHIDRA_EXTENSION_REPO_DIR/dist ./