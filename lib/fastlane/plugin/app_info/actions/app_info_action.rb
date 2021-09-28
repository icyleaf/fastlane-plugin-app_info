require 'app-info'
require 'terminal-table'

module Fastlane
  module Actions
    module SharedValues
      APP_INFO = :APP_INFO
    end

    class AppInfoAction < Action
      def self.run(params)
        file = params.fetch(:file)
        UI.user_error! 'You have to either pass an ipa, apk or aab file' unless file
        file = File.expand_path(file)
        app = ::AppInfo.parse(file)
        raw = Helper::AppInfoHelper.raw_data(app)

        UI.verbose "Raw params: #{raw}"
        print_table(raw)
        app.clear! if params.fetch(:clean)

        Helper::AppInfoHelper.store_sharedvalue(:APP_INFO, JSON.dump(raw))
        raw
      end

      def self.print_table(raw)
        puts Terminal::Table.new(
          title: "Summary for app_info #{AppInfo::VERSION}".green,
          rows: Helper::AppInfoHelper.hash_to_columns(raw)
        )
      end

      def self.description
        "Parse and dump mobile app(ipa, apk and aab file) metedata."
      end

      def self.authors
        ["icyleaf <icyleaf.cn@gmail.com>"]
      end

      def self.details
        "Teardown tool for mobile app(ipa, apk and aab file), analysis metedata like version, name, icon etc."
      end

      def self.return_value
        "Returns a Hash formated metadata of given app"
      end

      def self.output
        [
          [SharedValues::APP_INFO.to_s, 'The JSON formated metadata of given app']
        ]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :file,
                                       env_name: 'APP_INFO_FILE',
                                       description: 'Path to your ipa, apk and aab file file. Optional if you use the `gym`, `ipa` or `xcodebuild` action. ',
                                       default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] || Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] || Dir['*.ipa'].last || Dir['*.apk'].last,
                                       optional: true,
                                       verify_block: proc do |value|
                                         raise "Couldn't find app file".red unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :clean,
                                       env_name: 'APP_INFO_CLEAN',
                                       description: 'Clean cache files to reduce disk size',
                                       default_value: true,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        %i[ios android].include?(platform)
      end
    end
  end
end
