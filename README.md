<p align="center">
    <img width="171" height="184" src="ios_dependency_parser.png" />
    <h1 align="center">ios_dependency_parser plugin</h1>
</p>
<p align="center">
    <a href="https://rubygems.org/gems/fastlane-plugin-ios_dependency_parser"><img src="https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg" /></a>
    <a href="https://rubygems.org/gems/fastlane-plugin-ios_dependency_parser"><img src="https://badge.fury.io/rb/fastlane-plugin-ios_dependency_parser.svg" /></a>
    <a href="https://rubygems.org/gems/fastlane-plugin-ios_dependency_parser"><img src="http://ruby-gem-downloads-badge.herokuapp.com/fastlane-plugin-ios_dependency_parser?type=total" /></a>
</p>

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-ios_dependency_parser`, add it to your project by running:

```bash
fastlane add_plugin ios_dependency_parser
```

## About ios_dependency_parser

This plugin analyzes a [Cocoapods](https://cocoapods.org/) project dependencies by running `pod outdated` and parsing the results into an array of `Pods` available further on in the script via `lane_context[SharedValues::POD_ANALYZER_RESULTS]`.

[`Pod`](lib/fastlane/plugin/ios_dependency_parser/helper/pod.rb) object structure:
```javascript
{
    pod_name: 'Alamofire',
    current_version: '4.8.2',
    update_version: '4.9.0',
    latest: '5.0.0-rc.2'
}
```

You could use it, for example, to alert you when a dependency used in the project has changed its major version number (e.g. using [versionomy](https://github.com/dazuma/versionomy)).

## Example

In this example we'll assume running `pod outdated` returns the following:
```
The following pod updates are available:
- Alamofire 4.8.2 -> 4.9.0 (latest version 5.0.0-rc.2)
- Crashlytics 3.13.1 -> 3.13.1 (latest version 3.14.0)
- GoogleMaps 3.2.0 -> 3.2.0 (latest version 3.4.0)
- RxSwift 4.5.0 -> 4.5.0 (latest version 5.0.0)
```

Our objective will be to retrieve `Alamofire`'s  current and latest version numbers with the `alamofire` lane in the following Fastfile.

### Our Fastfile:

```ruby
fastlane_version "2.131.0"

default_platform :ios

platform :ios do

  desc "Check Alamofire version"
  lane :alamofire do
    parse_pod_dependencies()
    pods = lane_context[SharedValues::POD_ANALYZER_RESULTS]
    alamofire_pod = pods.detect { |pod| pod.pod_name == 'Alamofire' }
    puts("Alamofire current version: #{alamofire_pod.current_version}")
    puts("Alamofire latest version: #{alamofire_pod.latest}")
  end
end
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
