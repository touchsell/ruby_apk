module Android
  class ApplicationTag < GenericTag
    use_tag '/manifest/application'

    define_attribute :allow_task_reparenting, :alias => :allowTaskReparenting, :default => false, :type => :boolean
    define_attribute :allow_backup, :alias => :allowBackup, :default => true, :type => :boolean
    define_attribute :backup_agent, :alias =>:backupAgent, :lambda => lambda {|application_tag, value| value =~ /^\./ ? "#{application_tag.manifest.manifest_tag['package']}+#{value}" : value}
    define_attribute :banner
    define_attribute :debuggable, :default => false, :type => :boolean
    define_attribute :description
    define_attribute :enabled, :default => true, :type => :boolean
    define_attribute :has_code, :alias => :hasCode, :default => true, :type => :boolean

    define_attribute :hardware_accelerated, :alias => :hardwareAccelerated, :default => :lambda, :lambda => lambda{ |application_tag| application_tag.manifest.uses_sdk_tag[:min_sdk_version] > 13 || application_tag.manifest.uses_sdk_tag[:target_sdk_version] > 13 }, :type => :boolean

    define_attribute :kill_after_restore, :alias => :killAfterRestore, :default => true, :type => :boolean
    define_attribute :icon
    define_attribute :is_game, :alias => :isGame, :default => false, :type => :boolean
    define_attribute :large_heap, :alias => :largeHeap, :default => false, :type => :boolean
    define_attribute :label
    define_attribute :logo
    define_attribute :manage_space_activity, :alias => :manageSpaceActivity #TODO
    define_attribute :name
    define_attribute :permission
    define_attribute :persistent, :default => false, :type => :boolean
    define_attribute :process #TODO
    define_attribute :restore_any_version, :alias => :restoreAnyVersion, :default => false, :type => :boolean
    define_attribute :required_account_type, :alias => :requiredAccountType #TODO
    define_attribute :restricted_account_type, :alias => :restrictedAccountType #TODO

    define_attribute :supports_rtl, :alias => :supportsRtl, :default => :lambda, :lambda => lambda{ |application_tag| application_tag.manifest.uses_sdk_tag[:target_sdk_version] > 16}, :type => :boolean

    define_attribute :task_affinity, :alias => :taskAffinity #TODO
    define_attribute :test_only, :alias => :testOnly, :default => false, :type => :boolean
    define_attribute :theme #TODO
    define_attribute :ui_options, :alias => :uiOptions, :default => "none"
    define_attribute :vm_safe_mode, :alias => :vmSafeMode, :default => false, :type => :boolean
  end
end
