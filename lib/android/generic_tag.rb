class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless defined? Array.new.extract_options!
end

def to_b(s)
  !!(s =~ /^(true|t|yes|y|1)$/i)
end

module Android
  class GenericTag

    attr :tag
    attr :attr

    def initialize(manifest,elem)
      @manifest = manifest
      @attr = {}
      @tag = elem
    end

    def get_attribute_value(element_name, name, *args)
      options = args.extract_options!
      element = @manifest.doc.elements[element_name]
      unless element
        return options[:default]
      end
      value = element.attributes[name]
      unless  !@manifest.rsc.nil? && value =~ /^@(\w+\/\w+)|(0x[0-9a-fA-F]{8})$/
        return value || options[:default]
      end
      if options[:find_option]
         @manifest.rsc.nil? ? nil : @manifest.rsc.find(value, options[:find_option])
      else
        @manifest.rsc.nil? ? nil : @manifest.rsc.find(value)
      end
    end
  end
end
