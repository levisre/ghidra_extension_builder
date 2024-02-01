# Ghidra Plugin Builder

## Why?
Simply said, Ghidra is amazing, and It's updating too quickly that may broke some extensions.

I think that install + setup whole dev environment for Ghidra (`Eclipse`, `jdk`, `gradle`,...) just to be able to compile one plugin which I needed, is sooo horible. So I decided to use Docker to compile anything I want for newer Ghidra, without setting up anything on my real machine. 

## How?

> [!WARNING]  
> This script only support newer gradle build task of Ghidra (`buildExtension` inside `$GHIDRA_INSTALL_DIR/support/buildExtension.gradle`). So older plugins may not work (or need to update gradle build script).

> [!NOTE]  
> I've discarded 2 tasks `compileTestJava` and `buildHelp` (because `buildHelp` sometimes may fail on older plugins, and `compileTestJava` may requires `JUnit` (sometimes it could not be found)). Check `Dockerfile`.

Need `docker-buildkit` [Link](https://docs.docker.com/build/buildkit/)


Open `build.sh`, then edit 2 vars:

- `GHIDRA_RELEASE_PACKAGE_LINK`: The link to download ghidra release
- `GHIDRA_EXTENSION_REPO_LINK`: The link to repo of ghidra extension to clone

If there is no link supplied, the script will check inside current folder to find Ghidra root directory, also Extension root directory. Then it will fire up a container and build the extension based on supplied Ghidra version. 

The output (packaged extension) will be located at `out` folder.