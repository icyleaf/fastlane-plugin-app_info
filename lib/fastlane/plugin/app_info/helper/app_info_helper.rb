require 'json'

module Fastlane
  module Helper
    class AppInfoHelper
      COMMON_COLUMNS = %w[os name release_version build_version identifier size device_type]

      def self.hash_to_columns(raw)
        raw.each_with_object({}) do |(key, value), obj|
          next if value.respond_to?(:empty?) && value.empty?

          name = upcase(column_name(key, value))
          obj[name] = object_to_column(value)
        end
      end

      def self.raw_data(app)
        common_columns(app).merge(platform_columns(app))
      end

      def self.platform_columns(app)
        obj = {}

        if app.os == 'iOS'
          obj[upcase('release_type')] = app.release_type
          obj[upcase('archs')] = app.archs
          return {} unless app.mobileprovision && !app.mobileprovision.empty?

          app.mobileprovision.mobileprovision.each do |key, value|
            next if key == 'DeveloperCertificates' || key == 'Name' || key == 'DER-Encoded-Profile'
            obj[upcase(key)] = value
          end
        elsif app.os == 'Android'
          signs = app.signs.map(&:path)
          issuers = android_certificate_issuer(app)
          permissions = app.use_permissions
          features = app.use_features

          obj = {
            "MinSDKVersion" => app.min_sdk_version,
            "TargetSDKVersion" => app.target_sdk_version,
            "Signatures" => signs,
            "CertificateIssuers" => issuers,
            "UsePermissions" => permissions,
            "UseFeatures" => features,
          }
        end

        obj
      end

      def self.common_columns(app)
        COMMON_COLUMNS.each_with_object({}) do |key, hash|
          value = key == 'size' ? app.size(human_size: true) : app.send(key.to_sym)
          hash[upcase(key)] = value
        end
      end

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

      def self.upcase(key)
        return key.upcase if key == 'os'

        str = key.dup
        ['-', '_', '\s'].each do |s|
          str = str.gsub(/(?:#{s}+)([a-z])/) { $1.upcase }
        end

        return str.gsub(/(\A|\s)([a-z])/) { $1 + $2.upcase }
      end

      def self.android_certificate_issuer(app)
        app.certificates.each_with_object([]) do |cert, obj|
          issuer = cert.certificate.issuer.to_a.map {|c| [c[0], c[1]] }.flatten.each_slice(2).to_h
          obj << issuer.select{ |k, _| ['CN', 'OU', 'O'].include?(k) }
                       .map {|k, v| "#{k}:#{v}"}
                       .join(' ')
        end
      end

      def self.store_sharedvalue(key, value)
        Actions.lane_context[key] = value
        ENV[key.to_s] = value

        value
      end
    end
  end
end
