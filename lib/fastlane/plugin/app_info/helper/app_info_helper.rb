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
        %w[name release_version build_version identifier os size]
      end

      def self.app_to_json(app)
        data = common_columns.each_with_object({}) do |key, obj|
          name = key.downcase == 'os' ? key.upcase : key.split('_').map(&:capitalize).join('')
          value = key == 'size' ? app.size(true) : app.send(key.to_sym)
          obj[name] = value
        end

        if app.os == 'iOS' && app.mobileprovision && !app.mobileprovision.empty?
          app.mobileprovision.mobileprovision.each do |key, value|
            next if key == 'DeveloperCertificates'
            data[key] = value
          end
        elsif app.os == 'Android'
          data["MinSDKVersion"] = app.min_sdk_version
          data["TargetSDKVersion"] = app.target_sdk_version
          data["CertificateIssuers"] = android_certificate_issuer(app)
          data["Signatures"] = app.signs.map {|sign| sign.path }
          data["UsePermissions"] = app.use_permissions
          data["UseFeatures"] = app.use_features
        end

        JSON.dump(data)
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
