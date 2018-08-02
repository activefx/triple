module Triple
  class Schema

    # WARNING: Destructive operation
    #
    # Calling Triple::Schema.call will overwrite existing
    # database tables, use Triple::DB#setup instead
    #
    def self.call(**options)
      version = options.fetch(:version) { 1 }

      ActiveRecord::Schema.define(version: version) do
        create_table :sources, force: :cascade do |t|
          t.timestamps null: false
          t.string :name
          t.text :metadata
        end

        create_table :entities, force: :cascade do |t|
          t.timestamps null: false
          t.string :name
          t.text :metadata
        end

        create_table :concepts, force: :cascade do |t|
          t.timestamps null: false
          t.boolean :identifier, default: false
          t.string :name
          t.text :metadata
        end

        create_table :triples, force: :cascade do |t|
          t.timestamps null: false
          t.integer :source_id
          t.integer :entity_id
          t.integer :concept_id
          t.integer :value_id
          t.string :value_type
        end

        create_table :default_values, force: :cascade do |t|
          t.text :value
          t.text :metadata
        end

        create_table :boolean_values, force: :cascade do |t|
          t.boolean :value
        end

        create_table :string_values, force: :cascade do |t|
          t.string :value
        end

        create_table :integer_values, force: :cascade do |t|
          t.integer :value
        end

        create_table :real_values, force: :cascade do |t|
          t.float :value
        end

        create_table :numeric_values, force: :cascade do |t|
          t.text :value
          t.integer :precision
          t.integer :scale
        end

        create_table :date_values, force: :cascade do |t|
          t.date :value
        end

        create_table :time_values, force: :cascade do |t|
          t.time :value
        end

        create_table :datetime_values, force: :cascade do |t|
          t.datetime :value
        end

        create_table :binary_values, force: :cascade do |t|
          t.binary :value
          t.text :metadata
        end
      end
    end

  end
end
