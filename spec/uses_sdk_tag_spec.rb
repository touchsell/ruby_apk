require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "UsesSdkTag" do
  let(:doc_xml) {
    doc = REXML::Document.new()
    manifest_tag = REXML::Element.new("manifest")
    manifest_tag << REXML::Element.new("uses-sdk")
    manifest_tag.elements["uses-sdk"].add_attributes("minSdkVersion"    => 10,
                                                     "targetSdkVersion" => 12,
                                                     "maxSdkVersion"    => 15)
    doc << manifest_tag}

  let(:manifest){ Android::Manifest.new('mock data')}
  let(:uses_sdk_tag){Android::UsesSdkTag.new(manifest)}

  before do
    parser = double(Android::AXMLParser, :parse => doc_xml)
    Android::AXMLParser.stub(:new).and_return(parser)
  end

  describe ".tag" do
    subject { Android::UsesSdkTag.tag }
    it { should == "/manifest/uses-sdk" }
  end

  describe "#min_sdk_version" do
    context "when minSdkVersion is defined" do
      subject { uses_sdk_tag.min_sdk_version }
      it { should ==  10 }
    end

    context "when mindSdkVersion is not defined" do
      subject {
        manifest.doc.elements['/manifest/uses-sdk'].delete_attribute("minSdkVersion")
        uses_sdk_tag.min_sdk_version }
      it { should ==  1 }
    end
  end

  describe "#target_sdk_version" do
    context "when targetSdkVersion is defined" do
      subject { uses_sdk_tag.target_sdk_version }
      it { should ==  12 }
    end

    context "when targetSdkVersion is not defined" do
    subject {
      manifest.doc.elements['/manifest/uses-sdk'].delete_attribute("targetSdkVersion")
      uses_sdk_tag.target_sdk_version }
    it { should == uses_sdk_tag.min_sdk_version }
    end
  end

  describe "#max_sdk_version" do
    context "when maxSdkVersion is defined" do
      subject { uses_sdk_tag.max_sdk_version }
      it { should ==  15 }
    end
    context "when maxSdkVersion is not defined" do
      subject {
        manifest.doc.elements['/manifest/uses-sdk'].delete_attribute("maxSdkVersion")
        uses_sdk_tag.max_sdk_version }
      it {should == 0 }
    end
  end
end

