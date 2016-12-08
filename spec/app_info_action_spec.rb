describe Fastlane::Actions::AppInfoAction do
  describe '#run' do
    it 'should throws an exception' do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          app_info
        end").runner.execute(:test)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, 'You have to either pass an ipa or an apk file')
    end
  end
end
