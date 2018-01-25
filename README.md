# app_info plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-app_info)

## Getting Started

This project is a [fastlane](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-app_info`, add it to your project by running:

```bash
fastlane add_plugin app_info
```

## About app_info

Teardown tool for mobile app(ipa/apk), analysis metedata like version, name, icon etc.

## Configure

```+----------------------------------------------------------------------------------------+
|                                        app_info                                        |
+----------------------------------------------------------------------------------------+
| Parse and dump mobile app(ipa/apk) metedata.                                           |
|                                                                                        |
| Teardown tool for mobile app(ipa/apk), analysis metedata like version, name, icon etc. |
|                                                                                        |
| Created by icyleaf <icyleaf.cn@gmail.com>                                              |
+----------------------------------------------------------------------------------------+

+------+-------------------------------------------------+---------------+---------+
|                                 app_info Options                                 |
+------+-------------------------------------------------+---------------+---------+
| Key  | Description                                     | Env Var       | Default |
+------+-------------------------------------------------+---------------+---------+
| file | Path to your ipa/apk file. Optional if you use  | APP_INFO_FILE |         |
|      | the `gym`, `ipa` or `xcodebuild` action.        |               |         |
+------+-------------------------------------------------+---------------+---------+

+----------+---------------------------------+
|         app_info Output Variables          |
+----------+---------------------------------+
| Key      | Description                     |
+----------+---------------------------------+
| APP_INFO | the json formated app info data |
+----------+---------------------------------+
Access the output values using `lane_context[SharedValues::VARIABLE_NAME]`
```

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

## Example Output

### iOS

```bash
$ bundle exec fastlane action app_info
+-----------------------------+-------------------------------------------------+
|                          Summary for app_info 0.1.0                           |
+-----------------------------+-------------------------------------------------+
| Name                        | iOS Team Provisioning Profile: *                |
| ReleaseVersion              | 1.2.3                                           |
| BuildVersion                | 5                                               |
| Identifier                  | com.icyleaf.AppInfoDemo                         |
| Os                          | iOS                                             |
| AppIDName                   | XC Wildcard                                     |
| ApplicationIdentifierPrefix | **********                                      |
| CreationDate                | 2016-07-27 17:44:49 +0800                       |
| Platform                    | iOS                                             |
| Entitlements (4)            | keychain-access-groups: ["**********.*"]        |
|                             | get-task-allow: true                            |
|                             | application-identifier: **********.*            |
|                             | com.apple.developer.team-identifier: ********** |
| ExpirationDate              | 2017-07-27 17:44:49 +0800                       |
| ProvisionedDevices (2)      | ****************************************        |
|                             | ****************************************        |
| TeamIdentifier              | **********                                      |
| TeamName                    | EWS Inc                                         |
| TimeToLive                  | 365                                             |
| UUID                        | 3e5c38a0-1111-2222-3333-c508df973b15            |
| Version                     | 1                                               |
+-----------------------------+-------------------------------------------------+
```

### Android

```bash
+----------------+-------------------------+
|        Summary for app_info 0.1.0        |
+----------------+-------------------------+
| Name           | AppInfoDemo             |
| ReleaseVersion | 1.2.3                   |
| BuildVersion   | 5                       |
| Identifier     | com.icyleaf.appinfodemo |
| Os             | Android                 |
+----------------+-------------------------+
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
