require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ApplicationTag" do
  context "with real sample_AndroidManifest.xml data" do
    let(:bin_xml_path){ File.expand_path(File.dirname(__FILE__) + '/data/sample_AndroidManifest.xml') }
    let(:bin_xml){ File.open(bin_xml_path, 'rb') {|f| f.read } }
    let(:manifest){ Android::Manifest.new(bin_xml) }
    let(:application_tag){Android::ApplicationTag.new(manifest)}

    describe "class tag" do
      subject { application_tag.class.tag }
      it { should == "/manifest/application" }
    end

    describe "allow_task_reparenting" do
      subject { application_tag.allow_task_reparenting }
      it { should == false }
    end

    describe "allow_backup" do
      subject { application_tag.allow_backup }
      it { should == true }
    end

    describe "backup_agent" do
      subject { application_tag.backup_agent}
      it { should == nil}
    end

    describe "banner" do
      subject { application_tag.banner}
      it { should == nil}
    end

    describe "debuggable" do
      subject { application_tag.debuggable }
      it { should == true }
    end

    describe "description" do
      subject { application_tag.description }
      it { should == nil}
    end

    describe "enabled" do
      subject { application_tag.enabled }
      it { should == true }
    end

    describe "has_code" do
      subject { application_tag.has_code }
      it { should == true }
    end

    describe "hardware_accelerated" do
      subject { application_tag.hardware_accelerated }
      it { should == false }
    end

    describe "kill_after_Restore" do
      subject { application_tag.kill_after_restore }
      it { should == true }
    end

    describe "icon" do
      subject { application_tag.icon }
      it { should == "@0x7f020000" }
    end

    describe "is_game" do
      subject { application_tag.is_game }
      it { should == false }
    end

    describe "large_heap" do
      subject { application_tag.large_heap }
      it { should == false }
    end

    describe "label" do
      subject { application_tag.label }
      it { should == "@0x7f040001" }
    end

    describe "logo" do
      subject { application_tag.logo }
      it { should == nil }
    end

    describe "manage_space_activity" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end

    describe "name" do
      subject { application_tag.name }
      it { should == nil }
    end

    describe "permission" do
      subject { application_tag.permission }
      it { should == nil }
    end

    describe "persistent" do
      subject { application_tag.persistent }
      it { should == false }
    end

    describe "process" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end

    describe "restore_any_version" do
      subject { application_tag.restore_any_version }
      it { should == false }
    end

    describe "required_account_type" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end

    describe "restricted_account_type" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end

    describe "supports_rtl" do
      subject { application_tag.supports_rtl }
      it { should == false }
    end

    describe "task_affinity" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end

    describe "test_only" do
      subject { application_tag.test_only }
      it { should == false }
    end

    describe "theme" do
      skip "FUNCTIONNALITY NOT IMPLEMENTED"
    end

    describe "ui_options" do
      subject { application_tag.ui_options }
      it { should == "none" }
    end

    describe "vm_safe_mode" do
      subject { application_tag.vm_safe_mode }
      it { should == false }
    end
  end
end
