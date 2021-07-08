require 'json'

module Fastlane
  module Helper
    class AppInfoHelper
      COMMON_COLUMNS = %w[os name release_version build_version identifier size]

      def self.hash_to_columns(raw)
        raw.each_with_object({}) do |(key, value), obj|
          name = upcase(column_name(key, value))
          obj[name] = object_to_column(value)
        end
      end

      def self.raw_data(app)
        common_columns(app).merge(platform_columns(app))
      end

      def self.platform_columns(app)
        if app.os == 'iOS'
          return {} unless app.mobileprovision && !app.mobileprovision.empty?

          app.mobileprovision.mobileprovision.each_with_object({}) do |(key, value), hash|
            next if key == 'DeveloperCertificates' || key == 'Name' || key == 'DER-Encoded-Profile'

            hash[upcase(key)] = value
          end
        elsif app.os == 'Android'
          signs = app.signs.map { |f| f.path }
          issuers = android_certificate_issuer(app)
          permissions = app.use_permissions
          features = app.use_features

          {
            "MinSDKVersion" => app.min_sdk_version,
            "TargetSDKVersion" => app.target_sdk_version,
            "Signatures" => signs,
            "CertificateIssuers" => issuers,
            "UsePermissions" => permissions,
            "UseFeatures" => features,
          }
        else
          {}
        end
      end

      def self.common_columns(app)
        COMMON_COLUMNS.each_with_object({}) do |key, hash|
          value = key == 'size' ? app.size(true) : app.send(key.to_sym)
          hash[key] = value
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
        key == 'os' ? key.upcase : key.split('_').map(&:capitalize).join('')
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
