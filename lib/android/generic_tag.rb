module Android
  class GenericTag
    attr_accessor :manifest
    def initialize(manifest)
      @manifest = manifest
    end

    def get_attribute_value(element_name, name, options={})
      element = @manifest.doc.elements[element_name]
      return finalize_value(nil, options) unless element

      value = element.attributes[name]
      return finalize_value(value, options) unless value =~ /^@(\w+\/\w+)|(0x[0-9a-fA-F]{8})$/
      return finalize_value(value, options) unless @manifest.rsc

      return @manifest.rsc.find(value, options.select {|k,v| k == :find_option})
    end

    def finalize_value(value, options)
      value = value || options[:default]
      value = value.call(self) if value.is_a? Proc
      value = options[:value].call(self,value) if options[:value]

      value = self.class.to_b(value) if options[:type] == :boolean
      value = value.to_i if options[:type] == :integer

      return value
    end

    def self.to_b(value)
      case value
      when TrueClass  then true
      when FalseClass then false
      when NilClass   then false
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
      @attributes ||= Hash[self.class.attr_definitions.map { |k,opts| [k, __send__(k)] }]
    end
  end
end
