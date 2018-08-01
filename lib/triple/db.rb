module Triple
  class DB

    attr_reader :database, :namespace

    def initialize(**options)
      @database = options.fetch(:database) { Triple.default_database }
      @namespace = options.fetch(:namespace) { nil }
    end

  end
end
