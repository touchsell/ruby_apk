require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ManifestTag" do
  context "with real sample_AndroidManifest.xml data" do
    let(:bin_xml_path){ File.expand_path(File.dirname(__FILE__) + '/data/sample_AndroidManifest.xml') }
    let(:bin_xml){ File.open(bin_xml_path, 'rb') {|f| f.read } }
    let(:manifest){ Android::Manifest.new(bin_xml) }
    let(:manifest_tag){Android::ManifestTag.new(manifest)}

    describe ".tag" do
      subject { manifest_tag.class.tag }
      it { should == "/manifest" }
    end

    describe "#xmlns_android" do
      subject { manifest_tag.xmlns_android }
      it { should ==  "http://schemas.android.com/apk/res/android" }
    end

    describe "#package" do
      subject { manifest_tag.package }
      it { should == "example.app.sample" }
    end

    describe "#shared_user_id" do
      subject { manifest_tag.shared_user_id }
      it { should == nil }
    end

    describe "#shared_user_label" do
      subject { manifest_tag.shared_user_label }
      it { should == nil }
    end

    describe "#version_code" do
      subject { manifest_tag.version_code }
      it { should == 101 }
    end

    describe "#version_name" do
      subject { manifest_tag.version_name }
      it { should == "1.0.1-malware2" }
    end

    describe "#install_location" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end
  end
end

