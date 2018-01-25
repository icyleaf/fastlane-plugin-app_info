require 'json'

module Fastlane
  module Helper
    class AppInfoHelper
      def self.object_to_column(object)
        case object
        when Hash
          object.collect { |k, v| "#{k}: #{v}" }.join("\n")
        when Array
          object.join("\n")
        else
          object.to_s
        end
      end

      def self.column_name(key, value)
        case value
        when Array
          value.size > 1 ? "#{key} (#{value.size})" : key
        when Hash
          value.keys.size > 1 ? "#{key} (#{value.keys.size})" : key
        else
          key
        end
      end

      def self.common_columns
        %w[name release_version build_version identifier os]
      end

      def self.app_to_json(app)
        data = common_columns.each_with_object({}) do |key, obj|
          name = key.split('_').map(&:capitalize).join('')
          obj[name] = app.send(key.to_sym)
        end

        if app.os == 'iOS' && app.mobileprovision && !app.mobileprovision.empty?
          app.mobileprovision.mobileprovision.each do |key, value|
            next if key == 'DeveloperCertificates'
            data[key] = value
          end
        end

        JSON.dump(data)
      end

      def self.store_sharedvalue(key, value)
        Actions.lane_context[key] = value
        ENV[key.to_s] = value

        value
      end
    end
  end
end
