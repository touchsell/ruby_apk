require 'rexml/document'


class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless defined? Array.new.extract_options!
end

def to_b(s)
  !!(s =~ /^(true|t|yes|y|1)$/i)
end

module Android
  # parsed AndroidManifest.xml class
  # @see http://developer.android.com/guide/topics/manifest/manifest-intro.html
  class Manifest
    APPLICATION_TAG = '/manifest/application'

    # <activity>, <service>, <receiver> or <provider> element in <application> element of the manifest file.
    class Component
      # component types
      TYPES = ['service', 'activity', 'receiver', 'provider']

      # the element is valid Component element or not
      # @param [REXML::Element] elem xml element
      # @return [Boolean]
      def self.valid?(elem)
        TYPES.include?(elem.name.downcase)
      rescue
        false
      end

      # @return [String] type string in TYPES
      attr_reader :type
      # @return [String] component name
      attr_reader :name
      # @return [Array<Manifest::IntentFilter>]
      attr_reader :intent_filters
      # @return [Array<Manifest::Meta>]
      attr_reader :metas
      # @return [REXML::Element]
      attr_reader :elem


      # @param [REXML::Element] elem target element
      # @raise [ArgumentError] when elem is invalid.
      def initialize(elem)
        raise ArgumentError unless Component.valid?(elem)
        @elem = elem
        @type = elem.name
        @name = elem.attributes['name']
        @intent_filters = []
        unless elem.elements['intent-filter'].nil?
          elem.elements['intent-filter'].each do |e|
            next unless e.instance_of? REXML::Element
            @intent_filters << IntentFilter.parse(e)
          end
        end
        @metas = []
        elem.each_element('meta-data') do |e|
          @metas << Meta.new(e)
        end
      end
    end

    # intent-filter element in components
    module IntentFilter
      # parse inside of intent-filter element
      # @param [REXML::Element] elem target element
      # @return [IntentFilter::Action, IntentFilter::Category, IntentFilter::Data]
      #    intent-filter element
      def self.parse(elem)
        case elem.name
        when 'action'
          Action.new(elem)
        when 'category'
          Category.new(elem)
        when 'data'
          Data.new(elem)
        else
          nil
        end
      end

      # intent-filter action class
      class Action
      # @return [String] action name of intent-filter
        attr_reader :name
      # @return [String] action type of intent-filter
        attr_reader :type

        def initialize(elem)
          @type = 'action'
          @name = elem.attributes['name']
        end
      end

      # intent-filter category class
      class Category
      # @return [String] category name of intent-filter
        attr_reader :name
      # @return [String] category type of intent-filter
        attr_reader :type

        def initialize(elem)
          @type = 'category'
          @name = elem.attributes['name']
        end
      end

      # intent-filter data class
      class Data
        # @return [String]
        attr_reader :type
        # @return [String]
        attr_reader :host
        # @return [String]
        attr_reader :mime_type
        # @return [String]
        attr_reader :path
        # @return [String]
        attr_reader :path_pattern
        # @return [String]
        attr_reader :path_prefix
        # @return [String]
        attr_reader :port
        # @return [String]
        attr_reader :scheme

        def initialize(elem)
          @type = 'data'
          @host = elem.attributes['host']
          @mime_type = elem.attributes['mimeType']
          @path = elem.attributes['path']
          @path_pattern = elem.attributes['pathPattern']
          @path_prefix = elem.attributes['pathPrefix']
          @port = elem.attributes['port']
          @scheme = elem.attributes['scheme']
        end
      end
    end

    # meta information class
    class Meta
      # @return [String]
      attr_reader :name
      # @return [String]
      attr_reader :resource
      # @return [String]
      attr_reader :value
      def initialize(elem)
        @name = elem.attributes['name']
        @resource = elem.attributes['resource']
        @value = elem.attributes['value']
      end
    end

    #################################
    # Manifest class definitions
    #################################
    #
    # @return [REXML::Document] manifest xml
    attr_reader :doc
    attr_reader :rsc

    # @param [String] data binary data of AndroidManifest.xml
    def initialize(data, rsc=nil)
      parser = AXMLParser.new(data)
      @doc = parser.parse
      @rsc = rsc
    end

    # return some metadata about the apk
    def metadata
      metadata = {}
      metadata['manifest'] = ManifestTag.new(self).hash
      metadata['application'] = get_application_hash
      metadata ['uses-sdk'] = get_uses_sdk_hash
      metadata['uses-permission'] = use_permissions
      metadata
    end

    # used permission array
    # @return [Array<String>] permission names
    # @note return empty array when the manifest includes no use-permission element
    def use_permissions
      perms = []
      @doc.each_element('/manifest/uses-permission') do |elem|
        perms << elem.attributes['name']
      end
      perms.uniq
    end

    # created permission
    # TODO
    def permissions
      # TODO
      nil
    end

    # @return [Array<Android::Manifest::Component>] all components in apk
    # @note return empty array when the manifest include no components
    def components
      components = []
      unless @doc.elements['/manifest/application'].nil?
        @doc.elements['/manifest/application'].each do |elem|
          components << Component.new(elem) if Component.valid?(elem)
        end
      end
      components
    end


    ########################## APPLICATION ELEMENT
    APPLICATION = '/manifest/application'

    # return a hash with the options of the manifest element
    def get_application_hash
      result = {}
      result['allowTaskReparenting'] = allow_task_reparenting
      result['allowBackup'] = allow_backup
      result['backupAgent'] = backup_agent
      result['banner']   = banner
      result['debuggable'] = debuggable
      result['description'] = description
      result['enabled'] = enabled
      result['hasCode'] = has_code
      result['hardwareAccelerated'] = hardware_accelerated
      result['icon'] = icon
      result['isGame'] = is_game
      result['killAfterRestore'] = kill_after_restore
      result['largeHeap'] = large_heap
      result['label'] = label
      result['logo'] = logo
      result['name'] = name
      result['permission'] = permission
      result['persistent'] = persistent
      result['returnAnyVersion'] = return_any_version
      result['supportsRtl'] = supports_rtl
      result['testOnly'] = test_only
      result['uiOptions'] = ui_options
      result['vmSafeMode'] = vm_safe_mode
      result
    end


    # application allowTaskReparenting option
    # @return [TrueClass | FalseClass]
    # default value is false
    def allow_task_reparenting
      to_b get_attribute_value(APPLICATION, 'allowTaskReparenting', :default => false)
    end

    # application allowBackup option
    # @return [TrueClass | FalseClass]
    # default value is true
    def allow_backup
      to_b get_attribute_value(APPLICATION, 'allowBackup', :default => true)
    end

    # application backupAgent option
    # @return [string]
    # no default value
    def backup_agent
      attr = get_attribute_value(APPLICATION, 'backupAgent')
      attr =~ /^\./ ? "#{package}+#{attr}" : attr
    end

    # application banner
    # @return [string]
    # no default value
    def banner
      get_attribute_value(APPLICATION, 'banner')
    end

    # application debuggablee option
    # @return [TrueClass | FalseClass]
    # default value is false
    def debuggable
      to_b get_attribute_value(APPLICATION, 'debuggable', :default => false)
    end

    # application description option
    # @return [string]
    # no default value
    def description
      get_attribute_value(APPLICATION, 'description')
    end

    # application enabled option
    # @return [TrueClass | FalseClass]
    # default value is true
    def enabled
      to_b get_attribute_value(APPLICATION, 'enabled', :default => true)
    end

    # application hasCode option
    # @return [TrueClass | FalseClass]
    # default value is true
    def has_code
      to_b get_attribute_value(APPLICATION, 'hadCode', :default => true)
    end

    # application hardwareAccelerated option
    # @return [TrueClass | FalseClass]
    # default value is true if minSdkVersion or targetSdkVersion > 13 or false
    def hardware_accelerated
      if min_sdk_version > 13 || target_sdk_version > 13
        to_b get_attribute_value(APPLICATION, 'hardwareAccelerated', :default => true)
      else
        to_b get_attribute_value(APPLICATION, 'hardwareAccelerated', :default => false)
      end
    end

    # application icon
    # @return [Array] of strings
    # no default value
    def icon
      get_attribute_value(APPLICATION, 'icon')
    end

    # application isGame option
    # @return [TrueClass | FalseClass]
    # default value is false
    def is_game
      to_b get_attribute_value(APPLICATION, 'isGame', :default => false)
    end

    # application killAfterRestore option
    # @return [TrueClass | FalseClass]
    # default value is true
    def kill_after_restore
      to_b get_attribute_value(APPLICATION, 'killAfterRestore', :default => true)
    end

    # application largeHeap option
    # @return [TrueClass | FalseClass]
    # default value is false
    def large_heap
      to_b get_attribute_value(APPLICATION, 'largeHeap', :default => false)
    end

    # application label
    # @return [string]
    # no default value
    def label
      get_attribute_value(APPLICATION, 'label')
    end

    # application logo
    # @return [string]
    # no default value
    def logo
      get_attribute_value(APPLICATION, 'logo')
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
      get_attribute_value(APPLICATION, 'name')
    end

    # application permission set an application wide permission needed to use
    # the App
    # @return [string]
    # no default value
    def permission
      get_attribute_value(APPLICATION, 'permission')
    end

    # application persistence option
    # @return [TrueClass | FalseClass]
    # default value is false
    def persistent
      to_b get_attribute_value(APPLICATION, 'persistent', :default => false)
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
      to_b get_attribute_value(APPLICATION, 'restoreAnyVersion', :default => false)
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
      if target_sdk_version > 16
        to_b get_attribute_value(APPLICATION, 'supportsRtl', :default => true)
      else
        to_b get_attribute_value(APPLICATION, 'supportsRtl', :default => false)
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
      to_b get_attribute_value(APPLICATION, 'testOnly', :default => false)
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
      get_attribute_value(APPLICATION, 'iuOptions', :default => "none")
    end

    # application vmSafeMode option
    # @return [TrueClass | FalseClass]
    # default value is false
    def vm_safe_mode
      to_b get_attribute_value(APPLICATION, 'vmSafeMode', :default => false)
    end

    ##################################################################
    #################################### uses-sdk ELEMENT
    USES_SDK = '/manifest/uses-sdk'

    # 
    def get_uses_sdk_hash
      result={}
      result['minSdkVersion'] = min_sdk_version
      result['targetSdkVersion'] = target_sdk_version
      result['maxSdkVersion'] = max_sdk_version
      result
    end


    # @return [Integer] minSdkVersion in uses-sdk element
    # @return 1 when /manifest/uses-sdk is not found or attributes does not
    # exist cf http://developer.android.com/guide/topics/manifest/uses-sdk-element.html
    def min_sdk_version
      get_attribute_value(USES_SDK, 'minSdkVersion', :default => 1).to_i
    end

    # @return [Integer] targetSdkVersion in uses-sdk element
    # @return min_sdk_version when the attributes does not exist.
    def target_sdk_version
      get_attribute_value(USES_SDK, 'targetSdkVersion', :default => min_sdk_version).to_i
    end

    # @return [Integer] maxSdkVersion in uses-sdk element
    # should not be used according to official documentation at
    # http://developer.android.com/guide/topics/manifest/uses-sdk-element.html
    def max_sdk_version
      get_attribute_value(USES_SDK, 'maxSdkVersion', :default => 1).to_i
    end

    # ##############################################################
    # return xml as string format
    # @param [Integer] indent size(bytes)
    # @return [String] raw xml string
    def to_xml(indent=4)
      xml =''
      formatter = REXML::Formatters::Pretty.new(indent)
      formatter.write(@doc.root, xml)
      xml
    end
  end
end
