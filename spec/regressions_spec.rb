require 'spec_helper'

describe 'regressions' do
  let(:manifest) { Android::Manifest.new(File.open(manifest_file, 'rb').read) }
  let(:metadata) { manifest.metadata }

  context 'with periscope' do
    let(:manifest_file) { "spec/data/tv.periscope.android-AndroidManifest.xml" }

    it 'finds the version properly' do
      metadata['manifest']['version_name'].should == "1.0.4.1"
      metadata['manifest']['version_code'].should == 1900096
    end
  end

  context 'with fb' do
    let(:manifest_file) { "spec/data/com.facebook.katana-AndroidManifest.xml" }

    it 'finds the version properly' do
      metadata['manifest']['version_name'].should == "14.0.0.17.13"
      metadata['manifest']['version_code'].should == 3584822
    end
  end
end
