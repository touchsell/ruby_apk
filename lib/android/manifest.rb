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
      metadata['manifest'] = manifest_tag.attr
      metadata ['uses-sdk'] = uses_sdk_tag.attr
      metadata['application'] = application_tag.attr
      metadata['uses-permission'] = use_permissions
      metadata
    end

    def manifest_tag
      @manifest_tag ||= ManifestTag.new(self)
    end

    def application_tag
      @application_tag ||= ApplicationTag.new(self)
    end

    def uses_sdk_tag
      @uses_sdk_tag ||= UsesSdkTag.new(self)
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
