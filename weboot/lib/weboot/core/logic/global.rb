module Weboot
  module Logic
    class << self

      attr_accessor :weboot_dir, :root_dir
      attr_accessor :site
      attr_accessor :datasource_manager, :hook_manager, :filter_manager, :pipeline_manager

    end
  end
end
