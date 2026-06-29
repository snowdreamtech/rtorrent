# Changelog

## [0.9.8](https://github.com/snowdreamtech/rtorrent/compare/debian-v0.9.8...debian-v0.9.8) (2026-06-29)


### 🚀 Features

* **speckit:** implementation progress ([1780b43](https://github.com/snowdreamtech/rtorrent/commit/1780b431418fef9e62c9eafd72644dbfde1f7d4b))
* **speckit:** implementation progress ([740cb6c](https://github.com/snowdreamtech/rtorrent/commit/740cb6c0569257ec87f7253a5e448ebeb84e6dc5))


### 🐛 Bug Fixes

* **docker:** allow apt to match rtorrent binary suffix in debian and fix rocky base image versions ([cbea371](https://github.com/snowdreamtech/rtorrent/commit/cbea371bae3b2b30a1d3dd1fe4ac77966d5c91d8))
* **docker:** change node and php base image tags to generic variants ([9b0a21a](https://github.com/snowdreamtech/rtorrent/commit/9b0a21afed0ddb17ff60998800d4f0d4c99b4850))
* **docker:** copy config to variant subdirectories and restore context ([1a6798f](https://github.com/snowdreamtech/rtorrent/commit/1a6798fa4e9034388e2bfc2d4c70e3fc1afcd796))
* **docker:** replace --break-system-packages with PIP_BREAK_SYSTEM_PACKAGES=1 env var ([cb47101](https://github.com/snowdreamtech/rtorrent/commit/cb471018215a9e870ee83ee2508cd55eb036288a))
* remove pip self-upgrade command ([3d09ad3](https://github.com/snowdreamtech/rtorrent/commit/3d09ad3fbd1a8e3d848083aa4ce317b22ef7b9f7))
* resolve base image tags and package manager version bound errors ([8da1f76](https://github.com/snowdreamtech/rtorrent/commit/8da1f76099ebc7de66b0a8aa674468c3ccf58b4b))
* resolve build failures across alpine and rocky images ([088bc03](https://github.com/snowdreamtech/rtorrent/commit/088bc03646d28dc2242eb0218bf0ea8012f5933f))
* resolve CI failures for rutorrent, flood-alpine, and rocky ([314556e](https://github.com/snowdreamtech/rtorrent/commit/314556eec445c61693a636217db093ad85553566))
* resolve ruTorrent scgi connection and permission issues ([afa6970](https://github.com/snowdreamtech/rtorrent/commit/afa697032908357f73d1c632306549bcbecb813c))
* restore flood log output to docker engine for observability ([7a274c6](https://github.com/snowdreamtech/rtorrent/commit/7a274c626f9efdf97c5cadab0cb862eeb21fec66))
* revert unreleased base image updates ([60ec59b](https://github.com/snowdreamtech/rtorrent/commit/60ec59ba81ead499e05b158815419a8d06c5302e))
* use ghcr.io for base images to avoid rate limits ([9f1d73a](https://github.com/snowdreamtech/rtorrent/commit/9f1d73a75a61f2f368f5572c4bd28f4c92ef8fd5))
* use ghcr.io for base images to avoid rate limits and add npm for rocky flood ([df682ec](https://github.com/snowdreamtech/rtorrent/commit/df682ec12a362afe674fc0646fe282a7ef1dcdeb))


### ⚡️ Performance Improvements

* prevent recursive chown on massive directories and improve startup robustness ([b086afb](https://github.com/snowdreamtech/rtorrent/commit/b086afb5c39e00a957d316f7b262993392c97a08))


### 🛠 Refactoring

* **docker:** align Dockerfiles with base image structure ([232574f](https://github.com/snowdreamtech/rtorrent/commit/232574fed8418f8c7f257d001e951361dfa467a0))
* remove redundant docker-entrypoint.sh files ([87c576b](https://github.com/snowdreamtech/rtorrent/commit/87c576b27731ad11c5bc0ebc661e07c5a09ff1c1))
* reorganize distribution variants into docker directory ([67a8c91](https://github.com/snowdreamtech/rtorrent/commit/67a8c911e21801bf12b3e83d02e22f3b3f59a2ba))


### 📖 Documentation

* add detailed comments to entrypoint initialization scripts ([f42cbaa](https://github.com/snowdreamtech/rtorrent/commit/f42cbaab6edfbc5c38c2a636dfd8651fea900940))


### ♻️ Miscellaneous Chores

* **deps:** bump base images to alpine 3.24.0, debian 13.5.0, rocky 10.2.0 ([1688969](https://github.com/snowdreamtech/rtorrent/commit/168896956d2f4c7f91309c4c98ffef36ca7e8546))
* **deps:** update base images to latest versions ([caf3e7c](https://github.com/snowdreamtech/rtorrent/commit/caf3e7cada2383cc68d6896a00ff5788ccfb2c00))
* release main ([f66597a](https://github.com/snowdreamtech/rtorrent/commit/f66597a5feae95e8853f4cc730c81e93e172f6ca))
* release main ([b3a5cc9](https://github.com/snowdreamtech/rtorrent/commit/b3a5cc9ef0a64a7bc04ed7c2acf0cca5327c5c26))
* release main ([deb8454](https://github.com/snowdreamtech/rtorrent/commit/deb8454df7518d56939ab3851245a4cd7b03d709))
* release main ([d87cb81](https://github.com/snowdreamtech/rtorrent/commit/d87cb815685ad9b5b43d4b9a195c68dee2fd8065))
* release main ([78328d2](https://github.com/snowdreamtech/rtorrent/commit/78328d20bd3697d48ea90aee8d0eaa6af4ccc09c))
* release main ([b720ad5](https://github.com/snowdreamtech/rtorrent/commit/b720ad57dd1691d8ae07dcac7d46d0bd257af3a0))
* release main ([32dd84d](https://github.com/snowdreamtech/rtorrent/commit/32dd84de4be973395d0867b5d527d528948a35df))
* release main ([725c69f](https://github.com/snowdreamtech/rtorrent/commit/725c69fdcc222b5b83d0690629ce213a68c586ab))
* release main ([070b694](https://github.com/snowdreamtech/rtorrent/commit/070b694a702763b60fc6b057a81418320418cafa))
* release main ([36d1211](https://github.com/snowdreamtech/rtorrent/commit/36d1211036847a8c6aaa01a21a1c695a47b71d45))
* release main ([9ad4f94](https://github.com/snowdreamtech/rtorrent/commit/9ad4f9490832efdc310f2ebbd8c77f3404daf07f))
* release main ([b0684a3](https://github.com/snowdreamtech/rtorrent/commit/b0684a32a652e83506451e6056168cfec8b9142c))
* release main ([495e18a](https://github.com/snowdreamtech/rtorrent/commit/495e18a4babcb06a12c2f5aec9ea571d97cb32e3))
* release main ([d4a3a34](https://github.com/snowdreamtech/rtorrent/commit/d4a3a34b00a6b9f381cd5d556749c257516b2f08))
* release main ([28d9426](https://github.com/snowdreamtech/rtorrent/commit/28d94263f4374017274707faef7183917b689be9))
* **release:** deduplicate CHANGELOG headers ([82be3d5](https://github.com/snowdreamtech/rtorrent/commit/82be3d5576b65b7f69b1a9afb8604f2c8f0e47f7))
* **release:** deduplicate CHANGELOG headers ([d47fb44](https://github.com/snowdreamtech/rtorrent/commit/d47fb44cb105b368722d7d0e210a27b525f82d87))
* **release:** deduplicate CHANGELOG headers ([e795177](https://github.com/snowdreamtech/rtorrent/commit/e79517795d98b9f8292ef956586a6dc03932d03c))
* **release:** deduplicate CHANGELOG headers ([27919e4](https://github.com/snowdreamtech/rtorrent/commit/27919e4baf4aab5b2a2bf32a7d437b05a717c11b))
* **release:** deduplicate CHANGELOG headers ([438190d](https://github.com/snowdreamtech/rtorrent/commit/438190d297c151c75eca4912fdc22c285d5ec1ea))
* **release:** deduplicate CHANGELOG headers ([256f043](https://github.com/snowdreamtech/rtorrent/commit/256f04311b2344f2648ca5bcf407146f8c690258))
* **release:** deduplicate CHANGELOG headers ([d263aae](https://github.com/snowdreamtech/rtorrent/commit/d263aae7b223103a01dd0e114430381c5d863dd7))
* **release:** deduplicate CHANGELOG headers ([133954e](https://github.com/snowdreamtech/rtorrent/commit/133954e95cfae85cbba2fb9c1ac5acbc677ca39d))
* **release:** deduplicate CHANGELOG headers ([1d82410](https://github.com/snowdreamtech/rtorrent/commit/1d82410d6038be22d7741f1519826f30023b0f3e))
* **release:** deduplicate CHANGELOG headers ([5e1a539](https://github.com/snowdreamtech/rtorrent/commit/5e1a5390319933b48d20ad993714587d826c0aa7))
* **release:** implement automatic changelog deduplication step ([282c220](https://github.com/snowdreamtech/rtorrent/commit/282c22081e1ad7a1a010a7f297d20bc7c9b416a7))

## Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
