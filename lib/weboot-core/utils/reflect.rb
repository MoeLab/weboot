module Weboot

  # @raise NameError if not found
  def constantize(classpath, current = Object)
    names = classpath.split('::'.freeze)

    # Trigger a built-in NameError exception including the ill-formed constant in the message.
    current.const_get(classpath) if names.empty?

    if names.first.empty?
      current = Object
      names.shift
    end

    names.inject(current) do |current, name|
      # inherit=false
      current.const_get(name, false)
    end
  end

end
