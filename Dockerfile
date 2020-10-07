FROM openjdk:8-alpine
#FROM alvrme/alpine-android:latest
LABEL maintainer "schrader.tristan@gmail.com"

WORKDIR /tmp

# setup for SDK installation
ENV USER_HOME /home/developer
ENV ANDROID_SDK_ROOT /opt/sdks/android
ENV TOOLS_ID "6609375"
ENV BUILD_TOOLS "30.0.2"
ENV PATCHER_VERSION "v4"
ENV ANDROID_PLATFORM "android-30"
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/tools/bin
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools ${USER_HOME}/.android && \
    addgroup -S appgroup && \
    adduser -S developer -G appgroup && \
    touch ${USER_HOME}/.android/repositories.cfg

# Download Android SDK toolkit
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${TOOLS_ID}_latest.zip && \
    unzip sdk-tools.zip && \
    rm sdk-tools.zip && \
    mv tools/ ${ANDROID_SDK_ROOT}/cmdline-tools/tools

# Approve SDK licensing
RUN yes | sdkmanager --licenses && \
    sdkmanager "build-tools;${BUILD_TOOLS}" \
               "patcher;${PATCHER_VERSION}" \
               "platform-tools" \
               "platforms;${ANDROID_PLATFORM}" \
               "sources;${ANDROID_PLATFORM}"

# Install Flutter for development
ENV FLUTTER_ROOT /opt/sdks/flutter
ENV PATH ${PATH}:${FLUTTER_ROOT}/bin
RUN apk update && \
    apk add git bash curl && \
    mkdir -p /opt/sdks/flutter && \
    git clone -b stable https://github.com/flutter/flutter.git ${FLUTTER_ROOT} && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk && \
    apk add glibc-2.32-r0.apk && \
    /bin/bash flutter doctor

# Install Node and Firestore emulator
RUN apk add npm && \
    npm i -g firebase-tools && \
    firebase setup:emulators:firestore

USER developer
WORKDIR ${USER_HOME}