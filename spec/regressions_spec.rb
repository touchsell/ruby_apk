require 'spec_helper'

describe 'regressions' do
  let(:resource_file) { nil }
  let(:resource) { Android::Resource.new(File.open(resource_file, 'rb').read) if resource_file }
  let(:manifest) { Android::Manifest.new(File.open(manifest_file, 'rb').read, resource) }
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

  context 'with sears' do
    let(:manifest_file) { "spec/data/com.sears.android-AndroidManifest.xml" }
    let(:resource_file) { "spec/data/com.sears.android-resources.arsc" }

    it 'finds the version properly' do
      metadata['manifest']['version_name'].should == "6.2.22"
      metadata['manifest']['version_code'].should == 143
    end
  end

  context 'with free gift cards' do
    let(:manifest_file) { "spec/data/Free-Gift-Cards_2.1.6_apk-dl.com-AndroidManifest.xml" }
    let(:resource_file) { "spec/data/Free-Gift-Cards_2.1.6_apk-dl.com-resources.arsc" }

    it 'finds the version properly' do
      metadata['manifest']['version_name'].should == "2.1.6"
      metadata['manifest']['version_code'].should == 19
    end
  end
end
