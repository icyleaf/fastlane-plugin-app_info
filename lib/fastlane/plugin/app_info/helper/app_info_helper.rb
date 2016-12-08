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
    end
  end
end
