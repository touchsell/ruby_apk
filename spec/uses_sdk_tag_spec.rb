require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "UsesSdkTag" do
  context "with real sample_AndroidManifest.xml data" do
    let(:bin_xml_path){ File.expand_path(File.dirname(__FILE__) + '/data/sample_AndroidManifest.xml') }
    let(:bin_xml){ File.open(bin_xml_path, 'rb') {|f| f.read } }
    let(:manifest){ Android::Manifest.new(bin_xml) }
    let(:uses_sdk_tag){Android::UsesSdkTag.new(manifest)}

    describe "class tag" do
      subject { uses_sdk_tag.class.tag }
      it { should == "/manifest/uses-sdk" }
    end

    describe "min_sdk_version" do
      subject { uses_sdk_tag.min_sdk_version }
      it { should ==  10 }
    end

    describe "target_sdk_version" do
      subject { uses_sdk_tag.target_sdk_version }
      it { should == 10 }
    end

    describe "max_sdk_version" do
      subject { uses_sdk_tag.max_sdk_version }
      it {should == 0 }
    end
  end
end

