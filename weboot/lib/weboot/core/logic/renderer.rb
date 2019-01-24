module Weboot
  module Logic
    class << self

      def render
        @pages.each do |page|
          p page
        end
      end

    end
  end
end
