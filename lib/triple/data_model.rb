module Triple
  class DataModel

    def self.build(namespace:, connection_options:)
      klass = Object.const_set(
        namespace, Class.new(ActiveRecord::Base) do
          self.abstract_class = true
        end
      )

      @@connection = klass.establish_connection(connection_options)

      klass.const_set(
        "Source", Class.new(namespace.constantize) do
          self.table_name = "sources"
          has_many :triples, class_name: "#{klass}::Triple", dependent: :destroy
        end
      )

      klass.const_set(
        "Entity", Class.new(namespace.constantize) do
          self.table_name = "entities"
          has_many :triples, class_name: "#{klass}::Triple", dependent: :destroy
        end
      )

      klass.const_set(
        "Concept", Class.new(namespace.constantize) do
          self.table_name = "concepts"
          has_many :triples, class_name: "#{klass}::Triple", dependent: :destroy
        end
      )

      klass.const_set(
        "Triple", Class.new(namespace.constantize) do
          self.table_name = "triples"
          belongs_to :source, optional: true, class_name: "#{klass}::Source"
          belongs_to :entity, required: true, class_name: "#{klass}::Entity"
          belongs_to :concept, required: true, class_name: "#{klass}::Concept"
          belongs_to :value, polymorphic: true, required: true, dependent: :destroy
        end
      )

      klass.const_set(
        "DefaultValue", Class.new(namespace.constantize) do
          self.table_name = "default_values"
          has_one :triple, as: :value
          serialize :metadata, JSON
        end
      )

      klass.const_set(
        "BooleanValue", Class.new(namespace.constantize) do
          self.table_name = "boolean_values"
          has_one :triple, as: :value
        end
      )

      klass.const_set(
        "StringValue", Class.new(namespace.constantize) do
          self.table_name = "string_values"
          has_one :triple, as: :value
        end
      )

      klass.const_set(
        "IntegerValue", Class.new(namespace.constantize) do
          self.table_name = "integer_values"
          has_one :triple, as: :value
        end
      )

      # Floats
      klass.const_set(
        "RealValue", Class.new(namespace.constantize) do
          self.table_name = "real_values"
          has_one :triple, as: :value
        end
      )

      # Decimals
      klass.const_set(
        "NumericValue", Class.new(namespace.constantize) do
          self.table_name = "numeric_values"
          has_one :triple, as: :value
        end
      )

      klass.const_set(
        "DateValue", Class.new(namespace.constantize) do
          self.table_name = "date_values"
          has_one :triple, as: :value
        end
      )

      klass.const_set(
        "TimeValue", Class.new(namespace.constantize) do
          self.table_name = "time_values"
          has_one :triple, as: :value
        end
      )

      klass.const_set(
        "DatetimeValue", Class.new(namespace.constantize) do
          self.table_name = "datetime_values"
          has_one :triple, as: :value
        end
      )

      klass.const_set(
        "BinaryValue", Class.new(namespace.constantize) do
          self.table_name = "binary_values"
          has_one :triple, as: :value
        end
      )
    end

    def self.teardown(namespace:)
      @@connection.disconnect! if @@connection
      Object.send(:remove_const, namespace)
    end

  end
end
