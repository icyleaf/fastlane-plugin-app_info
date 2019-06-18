require 'app-info'
require 'terminal-table'

module Fastlane
  module Actions
    module SharedValues
      APP_INFO = :APP_INFO
    end

    class AppInfoAction < Action
      def self.run(params)
        @file = params.fetch(:file)
        UI.user_error! 'You have to either pass an ipa or an apk file' unless @file
        @file = File.expand_path(@file)
        @app = ::AppInfo.parse(@file)

        print_table!

        # Store shared value
        Helper::AppInfoHelper.store_sharedvalue(:APP_INFO, Helper::AppInfoHelper.app_to_json(@app))
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
        common_columns.merge(extra_columns)
      end

      def self.common_columns
        Helper::AppInfoHelper.common_columns.each_with_object({}) do |key, hash|
          name = key == 'os' ? key.upcase : key.split('_').map(&:capitalize).join('')
          value = key == 'size' ? @app.size(true) : @app.send(key.to_sym)
          hash[name] = Helper::AppInfoHelper.object_to_column(value)
        end
      end

      def self.extra_columns
        if @app.os == 'iOS'
          return {} unless @app.mobileprovision && !@app.mobileprovision.empty?

          @app.mobileprovision.mobileprovision.each_with_object({}) do |(key, value), hash|
            next if key == 'DeveloperCertificates'

            name = Helper::AppInfoHelper.column_name(key, value)
            hash[name] = Helper::AppInfoHelper.object_to_column(value)
          end
        elsif @app.os == 'Android'
          signs = @app.signs.map {|f| f.path }
          issuers = Helper::AppInfoHelper.android_certificate_issuer(@app)
          permissions = @app.use_permissions
          features = @app.use_features

          {
            "MinSDKVersion" => Helper::AppInfoHelper.object_to_column(@app.min_sdk_version),
            "TargetSDKVersion" => Helper::AppInfoHelper.object_to_column(@app.target_sdk_version),
            "Signatures" => Helper::AppInfoHelper.object_to_column(signs),
            "CertificateIssuers" => Helper::AppInfoHelper.object_to_column(issuers),
            "UsePermissions (#{permissions.size})" => Helper::AppInfoHelper.object_to_column(permissions),
            "UseFeatures (#{features.size})" => Helper::AppInfoHelper.object_to_column(features),
          }
        else
          {}
        end
      end

      def self.description
        "Parse and dump mobile app(ipa/apk) metedata."
      end

      def self.authors
        ["icyleaf <icyleaf.cn@gmail.com>"]
      end

      def self.details
        "Teardown tool for mobile app(ipa/apk), analysis metedata like version, name, icon etc."
      end

      def self.output
        [
          [SharedValues::APP_INFO.to_s, 'the json formated app info data']
        ]
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
        %i[ios android].include?(platform)
      end
    end
  end
end
