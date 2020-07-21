class AddTsvSearchableToProducts < ActiveRecord::Migration[6.0]
    def up
      add_column :products, :searchable, :tsvector
      add_index :products, :searchable, using: "gin"
      execute <<-SQL
        CREATE TRIGGER products_tsvector_searchable BEFORE INSERT OR UPDATE
        ON products FOR EACH ROW EXECUTE PROCEDURE
        tsvector_update_trigger(
        searchable, 'pg_catalog.english', item_name
        );
      SQL
      now = Time.current.to_s(:db)
      update("UPDATE products SET updated_at = '#{now}'")
    end
  
    def down
      execute <<-SQL
        DROP TRIGGER products_tsvector_searchable 
        ON products
      SQL
      remove_index :products, :searchable
      remove_column :products,:searchable
    end
  end