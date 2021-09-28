# app_info plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-app_info)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-app_info`, add it to your project by running:

```bash
fastlane add_plugin app_info
```

## About app_info

Teardown tool for mobile app(ipa, apk and aab file), analysis metedata like version, name, icon etc.

## Configure

```
+------------------------------------------------------------------------------------------------------+
|                                               app_info                                               |
+------------------------------------------------------------------------------------------------------+
| Parse and dump mobile app(ipa, apk and aab file) metedata.                                           |
|                                                                                                      |
| Teardown tool for mobile app(ipa, apk and aab file), analysis metedata like version, name, icon etc. |
|                                                                                                      |
| Created by icyleaf <icyleaf.cn@gmail.com>                                                            |
+------------------------------------------------------------------------------------------------------+

+-------+--------------------------------------------------------------------------+----------------+---------+
|                                              app_info Options                                               |
+-------+--------------------------------------------------------------------------+----------------+---------+
| Key   | Description                                                              | Env Var(s)     | Default |
+-------+--------------------------------------------------------------------------+----------------+---------+
| file  | Path to your ipa, apk and aab file file. Optional if you use the `gym`,  | APP_INFO_FILE  |         |
|       | `ipa` or `xcodebuild` action.                                            |                |         |
| clean | Clean cache files to reduce disk size                                    | APP_INFO_CLEAN | true    |
+-------+--------------------------------------------------------------------------+----------------+---------+
* = default value is dependent on the user's system

+-------------+-----------------------------------------+
|               app_info Output Variables               |
+-------------+-----------------------------------------+
| Key         | Description                             |
+-------------+-----------------------------------------+
| APP_INFO    | The JSON formated metadata of given app |
+-------------+-----------------------------------------+
Access the output values using `lane_context[SharedValues::VARIABLE_NAME]`

+-----------------------------------------------+
|             app_info Return Value             |
+-----------------------------------------------+
| Returns a Hash formated metadata of given app |
+-----------------------------------------------+
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Example Output

### iOS

```text
+-----------------------------+-------------------------------------------------+
|                          Summary for app_info 0.6.0                           |
+-----------------------------+-------------------------------------------------+
| OS                          | iOS                                             |
| Name                        | AppInfoDemo                                     |
| ReleaseVersion              | 1.2.3                                           |
| BuildVersion                | 5                                               |
| Identifier                  | com.icyleaf.AppInfoDemo                         |
| Size                        | 41.70 KB                                        |
| DeviceType                  | iPhone                                          |
| Releasetype                 | AdHoc                                           |
| Archs (2)                   | armv7                                           |
|                             | arm64                                           |
| Appidname                   | XC Wildcard                                     |
| Applicationidentifierprefix | 5PJA6N5A3B                                      |
| Creationdate                | 2016-07-27 17:44:49 +0800                       |
| Platform                    | iOS                                             |
| Entitlements (4)            | keychain-access-groups: ["5PJA6N5A3B.*"]        |
|                             | get-task-allow: true                            |
|                             | application-identifier: 5PJA6N5A3B.*            |
|                             | com.apple.developer.team-identifier: 5PJA6N5A3B |
| Expirationdate              | 2017-07-27 17:44:49 +0800                       |
| Provisioneddevices (100)    | 18cf53cddee60c52f9c97b1521e7cbf8342628da        |
|                             | ****************************************        |
| TeamIdentifier              | **********                                      |
| TeamName                    | EWS Inc                                         |
| TimeToLive                  | 365                                             |
| UUID                        | 3e5c38a0-1111-2222-3333-c508df973b15            |
| Version                     | 1                                               |
+-----------------------------+-------------------------------------------------+
```

### Android

```text
+--------------------+------------------------------+
|            Summary for app_info 0.6.0             |
+--------------------+------------------------------+
| OS                 | Android                      |
| Name               | AppInfoDemo                  |
| ReleaseVersion     | 1.2.3                        |
| BuildVersion       | 5                            |
| Identifier         | com.icyleaf.appinfodemo      |
| Size               | 2.93 MB                      |
| DeviceType         | Phone                        |
| Minsdkversion      | 14                           |
| Targetsdkversion   | 29                           |
| Signatures         | META-INF/CERT.RSA            |
| Certificateissuers | CN:Android Debug O:Android   |
| Usepermissions (2) | android.permission.BLUETOOTH |
|                    | android.permission.CAMERA    |
| Usefeatures        |                              |
+--------------------+------------------------------+
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/PluginsTroubleshooting.md) doc in the main `fastlane` repo.

## Using `fastlane` Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Plugins.md).

## About `fastlane`

`fastlane` is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
