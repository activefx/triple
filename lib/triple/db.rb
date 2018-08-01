module Triple
  class DB

    attr_reader :database

    def initialize(**options)
      @database = options.fetch(:database) { Triple.default_database }
      @namespace = options.fetch(:namespace) { nil }
    end

    def namespace
      if @namespace
        match = /\A([A-Z][a-z]*([A-Z][a-zA-Z]*)?)\z/.match(@namespace.to_s)
        match ? match.to_s : raise("Invalid namespace provided: " +
          "please use CamelCase for the namespace class or module name")
      end
    end

  end
end
