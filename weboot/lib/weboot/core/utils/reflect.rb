module Weboot
  class << self

    """
    @raise NameError if not found
    """
    def constantize(classpath, current = Object)
      names = classpath.split('::'.freeze)

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      current.const_get(classpath) if names.empty?

      if names.first.empty?
        current = Object
        names.shift
      end

      current.const_get(classpath, false)
      # names.inject(current) do |current, name|
      #   # inherit=false
      #   puts "%s :: %s" % [current, name]
      #   current.const_get(name, false)
      # end
    end

    def get_provider(classpath)
      return nil if classpath.nil?
      constantize(classpath, self) # self = ::Weboot
    end

  end
end
