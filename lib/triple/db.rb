module Triple
  class DB

    attr_reader :database, :version

    def initialize(**options)
      @database   = options.fetch(:database) { Triple.default_database }
      @namespace  = options.fetch(:namespace) { nil }
      @force      = options.fetch(:force) { false }
      @version    = Integer(options.fetch(:version) { 1 })
    end

    def namespace
      if @namespace
        match = /\A([A-Z][a-z]*([A-Z][a-zA-Z]*)?)\z/.match(@namespace.to_s)
        match ? match.to_s : raise("Invalid namespace provided: " +
          "please use CamelCase for the namespace class or module name")
      end
    end

    def force?
      @force == true
    end

    def using_connection?
      config = ActiveRecord::Base.connection_config
      config[:adapter]  == connection_options[:adapter] &&
      config[:database] == connection_options[:database]
    rescue ActiveRecord::ConnectionNotEstablished
      false
    end

    def connection_options
      { adapter: Triple.adapter, database: database }
    end

    def with_connection
      original = ActiveRecord::Base.remove_connection
      ActiveRecord::Base.establish_connection(connection_options)
      yield
    ensure
      ActiveRecord::Base.establish_connection(original) if original
    end

    def setup
      with_connection do
        load_schema
      end
    end

    private

    def require_connection!
      unless using_connection?
        raise "Connection not established with Triple::DB"
      end
    end

    def load_schema
      require_connection!
      current_version = ActiveRecord::Migrator.current_version
      if force? || current_version == 0
        Triple::Schema.call(version: version)
        unless ActiveRecord::Migrator.current_version == version
          raise 'An unknown error occured while loading the schema'
        end
      elsif current_version < version
        raise "Initialize with option `force: true` to update the schema version " +
          "(WARNING: THIS WILL OVERWRITE THE DATABASE). Set :version option to " +
          "#{current_version} if you do not want to update the schema."
      else
        true # no-op
      end
    end

  end
end
