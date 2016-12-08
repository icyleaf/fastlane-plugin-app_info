require 'app_info'
require 'terminal-table'

module Fastlane
  module Actions
    class AppInfoAction < Action
      def self.run(params)
        @file = params.fetch(:file)
        UI.user_error! 'You have to either pass an ipa or an apk file' unless @file
        @file = File.expand_path(@file)
        @app = ::AppInfo.parse(@file)

        print_table!
      end

      def self.print_table!
        params = {}
        params[:rows] = table_columns
        params[:title] = "Summary for app_info #{AppInfo::VERSION}".green

        puts ""
        puts Terminal::Table.new(params)
        puts ""
      end

      def self.table_columns
        common_columns.merge(ios_columns)
      end

      def self.common_columns
        %w(name release_version build_version identifier os).each_with_object({}) do |key, hash|
          name = key.split('_').map(&:capitalize).join('')
          hash[name] = Helper::AppInfoHelper.object_to_column(@app.send(key.to_sym))
        end
      end

      def self.ios_columns
        return {} unless @app.os == 'iOS' && @app.mobileprovision && !@app.mobileprovision.empty?

        @app.mobileprovision.mobileprovision.each_with_object({}) do |(key, value), hash|
          next if key == 'DeveloperCertificates'

          name = Helper::AppInfoHelper.column_name(key, value)
          hash[name] = Helper::AppInfoHelper.object_to_column(value)
        end
      end

      def self.description
        "Teardown tool for mobile app(ipa/apk), analysis metedata like version, name, icon etc."
      end

      def self.authors
        ["icyleaf"]
      end

      def self.details
        "Teardown tool for mobile app(ipa/apk), analysis metedata like version, name, icon etc."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :file,
                                       env_name: 'APP_INFO_FILE',
                                       description: 'Path to your ipa/apk file. Optional if you use the `gym`, `ipa` or `xcodebuild` action. ',
                                       default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] || Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] || Dir['*.ipa'].last || Dir['*.apk'].last,
                                       optional: true,
                                       verify_block: proc do |value|
                                         raise "Couldn't find app file".red unless File.exist?(value)
                                       end)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
