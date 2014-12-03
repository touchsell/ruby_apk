module Android
  class ApplicationTag < GenericTag
    APPLICATION_TAG = '/manifest/application'
    def initialize(manifest)
      super(manifest, APPLICATION_TAG)
      @attr = {}
      @attr['allowTaskReparenting'] = allow_task_reparenting
      @attr['allowBackup'] = allow_backup
      @attr['backupAgent'] = backup_agent
      @attr['banner']   = banner
      @attr['debuggable'] = debuggable
      @attr['description'] = description
      @attr['enabled'] = enabled
      @attr['hasCode'] = has_code
      @attr['hardwareAccelerated'] = hardware_accelerated
      @attr['icon'] = icon
      @attr['isGame'] = is_game
      @attr['killAfterRestore'] = kill_after_restore
      @attr['largeHeap'] = large_heap
      @attr['label'] = label
      @attr['logo'] = logo
      @attr['name'] = name
      @attr['permission'] = permission
      @attr['persistent'] = persistent
      @attr['returnAnyVersion'] = return_any_version
      @attr['supportsRtl'] = supports_rtl
      @attr['testOnly'] = test_only
      @attr['uiOptions'] = ui_options
      @attr['vmSafeMode'] = vm_safe_mode
    end


    # application allowTaskReparenting option
    # @return [TrueClass | FalseClass]
    # default value is false
    def allow_task_reparenting
      to_b get_attribute_value(APPLICATION_TAG, 'allowTaskReparenting', :default => false)
    end

    # application allowBackup option
    # @return [TrueClass | FalseClass]
    # default value is true
    def allow_backup
      to_b get_attribute_value(APPLICATION_TAG, 'allowBackup', :default => true)
    end

    # application backupAgent option
    # @return [string]
    # no default value
    def backup_agent
      attr = get_attribute_value(APPLICATION_TAG, 'backupAgent')
      attr =~ /^\./ ? "#{@manifest.manifest_tag.attr['package']}+#{attr}" : attr
    end

    # application banner
    # @return [string]
    # no default value
    def banner
      get_attribute_value(APPLICATION_TAG, 'banner')
    end

    # application debuggablee option
    # @return [TrueClass | FalseClass]
    # default value is false
    def debuggable
      to_b get_attribute_value(APPLICATION_TAG, 'debuggable', :default => false)
    end

    # application description option
    # @return [string]
    # no default value
    def description
      get_attribute_value(APPLICATION_TAG, 'description')
    end

    # application enabled option
    # @return [TrueClass | FalseClass]
    # default value is true
    def enabled
      to_b get_attribute_value(APPLICATION_TAG, 'enabled', :default => true)
    end

    # application hasCode option
    # @return [TrueClass | FalseClass]
    # default value is true
    def has_code
      to_b get_attribute_value(APPLICATION_TAG, 'hadCode', :default => true)
    end

    # application hardwareAccelerated option
    # @return [TrueClass | FalseClass]
    # default value is true if minSdkVersion or targetSdkVersion > 13 or false
    def hardware_accelerated
      if @manifest.uses_sdk_tag.attr['minSdkVersion'] > 13 || @manifest.uses_sdk_tag.attr['targetSdkVersion'] > 13
        to_b get_attribute_value(APPLICATION_TAG, 'hardwareAccelerated', :default => true)
      else
        to_b get_attribute_value(APPLICATION_TAG, 'hardwareAccelerated', :default => false)
      end
    end

    # application icon
    # @return [Array] of strings
    # no default value
    def icon
      get_attribute_value(APPLICATION_TAG, 'icon')
    end

    # application isGame option
    # @return [TrueClass | FalseClass]
    # default value is false
    def is_game
      to_b get_attribute_value(APPLICATION_TAG, 'isGame', :default => false)
    end

    # application killAfterRestore option
    # @return [TrueClass | FalseClass]
    # default value is true
    def kill_after_restore
      to_b get_attribute_value(APPLICATION_TAG, 'killAfterRestore', :default => true)
    end

    # application largeHeap option
    # @return [TrueClass | FalseClass]
    # default value is false
    def large_heap
      to_b get_attribute_value(APPLICATION_TAG, 'largeHeap', :default => false)
    end

    # application label
    # @return [string]
    # no default value
    def label
      get_attribute_value(APPLICATION_TAG, 'label')
    end

    # application logo
    # @return [string]
    # no default value
    def logo
      get_attribute_value(APPLICATION_TAG, 'logo')
    end

    # application manageSpaceActivity
    # TODO
    def manage_space_activity
      # TODO
      nil
    end

    # application name of an Application subclass to be instantiated
    # @return [string]
    # no default value - default Application class is used
    def name
      get_attribute_value(APPLICATION_TAG, 'name')
    end

    # application permission set an application wide permission needed to use
    # the App
    # @return [string]
    # no default value
    def permission
      get_attribute_value(APPLICATION_TAG, 'permission')
    end

    # application persistence option
    # @return [TrueClass | FalseClass]
    # default value is false
    def persistent
      to_b get_attribute_value(APPLICATION_TAG, 'persistent', :default => false)
    end

    # application process option
    # TODO
    def process
      # TODO
      nil
    end

    # application restoreAnyVersion option
    # @return [TrueClass | FalseClass]
    # default value is false
    def return_any_version
      to_b get_attribute_value(APPLICATION_TAG, 'restoreAnyVersion', :default => false)
    end

    # application requiredAccountType
    # TODO
    def required_account_type
      # TODO
      nil
    end

    # applicationrestrictedAccountType
    # TODO
    def restricted_account_type
      # TODO
      nil
    end

    # application supportsRtl option
    # Added at Apk level 17
    # @return [TrueClass | FalseClass]
    # default value is false if targetSdkVersion <= 16 else default is true
    def supports_rtl
      if @manifest.uses_sdk_tag.attr['targetSdkVersion'] > 16
        to_b get_attribute_value(APPLICATION_TAG, 'supportsRtl', :default => true)
      else
        to_b get_attribute_value(APPLICATION_TAG, 'supportsRtl', :default => false)
      end
    end

    # application taskAffinity
    # TODO
    def task_affinity
      # TODO
      nil
    end

    # application testOnly option
    # @return [TrueClass | FalseClass]
    # default value is false
    def test_only
      to_b get_attribute_value(APPLICATION_TAG, 'testOnly', :default => false)
    end

    # application theme
    # TODO
    def theme
      # TODO
      nil
    end

    # application uiOptions
    # @return [string]
    # default is "none"
    def ui_options
      get_attribute_value(APPLICATION_TAG, 'iuOptions', :default => "none")
    end

    # application vmSafeMode option
    # @return [TrueClass | FalseClass]
    # default value is false
    def vm_safe_mode
      to_b get_attribute_value(APPLICATION_TAG, 'vmSafeMode', :default => false)
    end
  end
end
