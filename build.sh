#!/bin/bash

set -e

BAZEL_VERSION="6.5.0"
BAZEL_DIST_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip"
BAZEL_DOWNLOAD_DIR="bazel-${BAZEL_VERSION}"

sudo yum install -y python3 java-11-openjdk-devel zip unzip zlib-devel findutils gcc-c++ which bash-completion
sudo ln -s /usr/bin/python3 /usr/bin/python

# 选择 Java 11
JAVA_11_PATH=$(readlink -f /usr/lib/jvm/java-11-openjdk-*)
if [ -n "$JAVA_11_PATH" ]; then
  sudo alternatives --set java "$JAVA_11_PATH/bin/java"
  export JAVA_HOME="$JAVA_11_PATH"
  export PATH="$JAVA_HOME/bin:$PATH"
else
  echo "Java 11 not found, please install it manually."
  exit 1
fi

wget -q ${BAZEL_DIST_URL} -O ${BAZEL_DOWNLOAD_DIR}.zip
unzip -q ${BAZEL_DOWNLOAD_DIR}.zip -d ${BAZEL_DOWNLOAD_DIR}
cd ${BAZEL_DOWNLOAD_DIR}

patch -p1 < ../bazel-650-dist-riscv.patch
patch -p1 < ../distdir_deps-riscv.patch

mkdir -p third_party/abseil-cpp
cp ../abseil-cpp-202308020-riscv.patch third_party/abseil-cpp/

export BAZEL_JAVAC_OPTS="-J-Xmx2g -J-Xms200m"
export EXTRA_BAZEL_ARGS="${EXTRA_BAZEL_ARGS} --python_path=/usr/bin/python3 --sandbox_debug --tool_java_runtime_version=local_jdk --verbose_failures --subcommands --explain=build.log --show_result=2147483647"
export SOURCE_DATE_EPOCH="$(date -d $(head -1 CHANGELOG.md | grep -Eo '\b[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}\b' ) +%s)"
export EMBED_LABEL="${BAZEL_VERSION}"

./compile.sh

./scripts/generate_bash_completion.sh --bazel=output/bazel --output=output/bazel-complete.bash

BAZEL_OUTPUT_DIR="../bazel-${BAZEL_VERSION}-riscv64"
mkdir -p ${BAZEL_OUTPUT_DIR}/bin ${BAZEL_OUTPUT_DIR}/share/bash-completion/completions/

cp output/bazel ${BAZEL_OUTPUT_DIR}/bin/bazel-real
cp output/bazel ${BAZEL_OUTPUT_DIR}/bin/bazel-${BAZEL_VERSION}-riscv64
cp ./scripts/packages/bazel.sh ${BAZEL_OUTPUT_DIR}/bin/bazel
cp output/bazel-complete.bash ${BAZEL_OUTPUT_DIR}/share/bash-completion/completions/bazel

echo "Bazel ${BAZEL_VERSION} for RISC-V binaries are placed in $(realpath ${BAZEL_OUTPUT_DIR})!"

