describe Fastlane::Actions::AppInfoAction do
  describe '#run' do
    it 'should throws an exception' do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          app_info
        end").runner.execute(:test)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, 'You have to either pass an ipa or an apk file')
    end

    context 'when iOS' do
      describe '#output' do
        before do
          Fastlane::FastFile.new.parse("lane :ios do
            app_info(file: '../spec/fixtures/iphone.ipa')
          end").runner.execute(:ios)
        end

        context "-> lane_context[SharedValues::APP_INFO]" do
          subject { Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::APP_INFO] }

          it 'should be string' do
            expect(subject).to be_kind_of String
          end

          it 'should be parsed to json object' do
            expect(JSON.parse(subject)).to be_kind_of Hash
          end

          it 'should fetch item of json object' do
            app_info = JSON.parse(subject)
            expect(app_info['ReleaseVersion']).to eq '1.2.3'
            expect(app_info['BuildVersion']).to eq '5'
            expect(app_info['Identifier']).to eq 'com.icyleaf.AppInfoDemo'
            expect(app_info['OS']).to eq 'iOS'
            expect(app_info['Size']).to eq '41.70 KB'
            expect(app_info['ProvisionedDevices']).to be_kind_of Array
            expect(app_info['ProvisionedDevices'].size).to eq 100
          end
        end

        context "-> ENV['APP_INFO']" do
          subject { ENV['APP_INFO'] }

          it 'should be string' do
            expect(subject).to be_kind_of String
          end

          it 'should be parsed to json object' do
            expect(JSON.parse(subject)).to be_kind_of Hash
          end

          it 'should fetch item of json object' do
            app_info = JSON.parse(subject)
            expect(app_info['ReleaseVersion']).to eq '1.2.3'
            expect(app_info['BuildVersion']).to eq '5'
            expect(app_info['Identifier']).to eq 'com.icyleaf.AppInfoDemo'
            expect(app_info['OS']).to eq 'iOS'
            expect(app_info['Size']).to eq '41.70 KB'
            expect(app_info['ProvisionedDevices']).to be_kind_of Array
            expect(app_info['ProvisionedDevices'].size).to eq 100
          end
        end
      end
    end

    context 'when Android' do
      describe '#output' do
        before do
          Fastlane::FastFile.new.parse("lane :android do
            app_info(file: '../spec/fixtures/android.apk')
          end").runner.execute(:android)
        end

        context "-> lane_context[SharedValues::APP_INFO]" do
          subject { Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::APP_INFO] }

          it 'should be string' do
            expect(subject).to be_kind_of String
          end

          it 'should be parsed to json object' do
            expect(JSON.parse(subject)).to be_kind_of Hash
          end

          it 'should fetch item of json object' do
            app_info = JSON.parse(subject)
            expect(app_info['ReleaseVersion']).to eq '1.2.3'
            expect(app_info['BuildVersion']).to eq '5'
            expect(app_info['Identifier']).to eq 'com.icyleaf.appinfodemo'
            expect(app_info['OS']).to eq 'Android'
            expect(app_info['Size']).to eq '2.93 MB'
            expect(app_info['MinSDKVersion']).to eq 14
            expect(app_info['TargetSDKVersion']).to eq 29
            expect(app_info['Signatures']).to be_kind_of Array
            expect(app_info['Signatures'].size).to eq 1
            expect(app_info['CertificateIssuers']).to be_kind_of Array
            expect(app_info['CertificateIssuers'].first).to eq 'CN:Android Debug O:Android'
            expect(app_info['UsePermissions']).to be_kind_of Array
            expect(app_info['UsePermissions'].size).to eq 2
            expect(app_info['UseFeatures']).to be_kind_of Array
            expect(app_info['UseFeatures'].size).to eq 0
          end
        end

        context "-> ENV['APP_INFO']" do
          subject { ENV['APP_INFO'] }

          it 'should be string' do
            expect(subject).to be_kind_of String
          end

          it 'should be parsed to json object' do
            expect(JSON.parse(subject)).to be_kind_of Hash
          end

          it 'should fetch item of json object' do
            app_info = JSON.parse(subject)
            expect(app_info['ReleaseVersion']).to eq '1.2.3'
            expect(app_info['BuildVersion']).to eq '5'
            expect(app_info['Identifier']).to eq 'com.icyleaf.appinfodemo'
            expect(app_info['OS']).to eq 'Android'
            expect(app_info['Size']).to eq '2.93 MB'
            expect(app_info['MinSDKVersion']).to eq 14
            expect(app_info['TargetSDKVersion']).to eq 29
            expect(app_info['Signatures']).to be_kind_of Array
            expect(app_info['Signatures'].size).to eq 1
            expect(app_info['CertificateIssuers']).to be_kind_of Array
            expect(app_info['CertificateIssuers'].first).to eq 'CN:Android Debug O:Android'
            expect(app_info['UsePermissions']).to be_kind_of Array
            expect(app_info['UsePermissions'].size).to eq 2
            expect(app_info['UseFeatures']).to be_kind_of Array
            expect(app_info['UseFeatures'].size).to eq 0
          end
        end
      end
    end
  end
end
