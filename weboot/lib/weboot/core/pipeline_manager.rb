module Weboot
  class PipelineManager

    def initialize
      @pipelines = []
      @names = {}
    end

    def add(pipeline)
      @pipelines.append(pipeline)
      name = pipeline.name
      @names[name] = pipeline unless name.nil?
    end

    def match(filename)
      @pipelines.each do |pipeline|
        return pipeline if pipeline.match(filename)
      end
      nil
    end

    def get(name)
      @names[name]
    end

  end
end
