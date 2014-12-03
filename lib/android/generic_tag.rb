module Android
  class GenericTag
    attr_accessor :manifest
    def initialize(manifest)
      @manifest = manifest
    end

    def get_attribute_value(element_name, name, options={})
      element = @manifest.doc.elements[element_name]
      unless element
        return return_value(nil, options)
      end
      value = element.attributes[name]
      unless  !@manifest.rsc.nil? && !!(value =~ /^@(\w+\/\w+)|(0x[0-9a-fA-F]{8})$/)
        return return_value(value, options)
      end
      if options[:find_option]
         @manifest.rsc.nil? ? nil : @manifest.rsc.find(value, options[:find_option])
      else
        @manifest.rsc.nil? ? nil : @manifest.rsc.find(value)
      end
    end

    def return_value(value, options)
      if options[:lambda]
        value = options[:lambda].call(self, value)  if options[:default] != :lambda
        value = options[:lambda].call self          if options[:default] == :lambda
      end
      value = self.class.to_b(value) if options[:type] == :boolean
      value = value.to_i if options[:type] == :integer

      return value
    end

    def self.to_b(value)
      case value
      when TrueClass  then true
      when FalseClass then false
      when String, Integer
        value = value.to_s.strip.downcase
        return true  if %w(true yes t 1).include? value
        return false if %w(false no f 0).include? value
        return value
      else value
      end
    end

    class << self; attr_accessor :tag, :attr_definitions; end
    def self.use_tag(tag)
      @tag = tag
      @attr_definitions = {}
    end

    def self.define_attribute(name, options={})
      @attr_definitions[name] = options
      tag_alias = (options[:alias] || name).to_s
      define_method(name) { get_attribute_value(self.class.tag, tag_alias, options) }
    end

    def attributes
      # par exemple
      @attributes ||= Hash[self.class.attr_definitions.map { |k,opts| [k, __send__(k)] }]
    end
  end
end
