# Changelog

## [1.4.0](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.3.1...v1.4.0) (2026-06-29)


### ✨ New Features

* explicitly errors on unknown dns config topology ([598db32](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/598db32e0b4b2a7bd9e6a4da8f5baef85d4a7d1e))
* improve restart of dnsmasq, avoids kill when no pids present ([3f0019f](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/3f0019fbf7ee0ac6168890e4b48f5d04b9f35524))
* install script requires --update flag to allow overwriting existing files ([8d65a05](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/8d65a052fa547d7c3419ec126d7721851009a821))


### 🐛 Bug Fixes

* empty script created on failed download ([211f8f8](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/211f8f8a3a584686c82e38d17ac5b4452ff61f11))
* remove empty lines ([8d1108a](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/8d1108a1a54e9a601c266b78799834b95aec571a))
* use bash for the install script ([2069b2f](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/2069b2f2ccb7e15e3f18fb513e249d043083ad18))

## [1.3.1](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.3.0...v1.3.1) (2026-02-21)


### 🐛 Bug Fixes

* set shebangs to use bash ([4e1baef](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/4e1baef4cb007813884dc938edb2f40819a7afbe))

## [1.3.0](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.2.1...v1.3.0) (2026-02-21)


### ✨ New Features

* add support for `/data` folder if it exists when the firmware version is not recognized ([6ff55e8](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/6ff55e8cc25b1b947f7dbeec01cea0943dd6dca1))
* add support for unifi os 5 ([968d2b3](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/968d2b3bdf2241abb0fbdc86813b8a9fec4e2fe6))


### 🐛 Bug Fixes

* env and she bang ([89d4502](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/89d45021a815d16f893bdf274ae8847c9d6942e9))

## [1.2.1](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.2.0...v1.2.1) (2025-08-01)


### 📚 Documentation

* fix typos and add clarification about the script and the on-boot script requirements ([3f5d6d6](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/3f5d6d62648b071fc9251ab3369327ddb7eefb56))

## [1.2.0](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.1.1...v1.2.0) (2025-07-29)


### ✨ New Features

* execute init script during install ([aae2ad5](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/aae2ad591f1e85f776a4180d31c13bf64b9444b0))


### 🐛 Bug Fixes

* add executable flag to sh scripts ([08b380b](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/08b380b2e0bae37734dcbe0d35c61a4a91872fbb))


### 📚 Documentation

* fix installer path ([fab821a](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/fab821a30063c8471c4122f34486e41d2192b9f8))

## [1.1.1](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.1.0...v1.1.1) (2025-07-29)


### 🐛 Bug Fixes

* rename install-remote.sh to remote-install.sh ([2ddd3eb](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/2ddd3eb60f4e70f3bb969b16334e0fc70eb07c0a))

## [1.1.0](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v1.0.0...v1.1.0) (2025-07-27)


### ✨ New Features

* add an install script ([6aa2d3a](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/6aa2d3afb762c974b034ffa3ebb6cdf136f551f0))


### 📚 Documentation

* remove ambiguity in the intro about input file ([c0ee71a](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/c0ee71a3036e37ad3164676c3aa4a8505153f120))


### 🚦 CI

* add doc singular as a vaild documentation section ([1d86dcd](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/1d86dcda81b3cd08e43a61a6caf40daabe4ee819))

## [1.0.0](https://github.com/slawo/unifios-utilities-dnsmasq-update/compare/v0.0.1...v1.0.0) (2025-07-27)


### ⚠ BREAKING CHANGES

* change the name of the patched block

### ✨ New Features

* add a script to initialize the update script and cron job ([3dbb6ba](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/3dbb6bab880f4978d4c73a265d09f0a3605b3ff7))
* change the name of the patched block ([1c20e3b](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/1c20e3bc90f84db8619f97e8e01445ea2d778ec9))
* prevents running more than one instance of the script ([7fb2de9](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/7fb2de9f9714a2e7abbb2bdc82be56918e740444))

## 0.0.1 (2025-07-26)


### ✨ New Features

* adds the dns update script ([d8369dd](https://github.com/slawo/unifios-utilities-dnsmasq-update/commit/d8369dddb7e6c9142d91a046840a854c35e12619))
