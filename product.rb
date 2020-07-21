class Product < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :search_any,
                    against: :item_name,
                    using: {
                        tsearch: {
                            dictionary: 'english',
                            tsvector_column: 'searchable',
                            any_word: true
                        },
                        trigram: {
                            word_similarity: true
                        }
                    }
    has_one_attached :image
    has_many :line_items
    before_destroy :ensure_not_referenced_by_any_line_item
  
    has_many :pricelists, class_name: 'Pricelist',foreign_key: 'item_code', primary_key: 'item_code'
  
    before_destroy :ensure_not_referenced_by_any_line_item
    #TODO refactor enums to hash
    enum vol_units:['cmm', 'ml', 'l', 'm3', 'ci', 'ft3', 'foz', 'gal']
    enum weight_units:['mg', 'g', 'kg', 'oz', 'lb']
    enum product_units: ['box', 'cm', 'ct', 'ea', 'each', 'fl', 'fo', 'g', 'gal', 'kg', 'l', 'lb', 'm', 'ml', 'oz', 'roll'],
         _suffix: true
    validates_presence_of :item_code, :item_name, :item_size, :item_size_unit, :items_per_case,
                          :case_volume, :case_volume_unit, :case_weight, :case_weight_unit
    validates_uniqueness_of :item_code
  
    private
  
    def ensure_not_referenced_by_any_line_item
      unless line_items.empty?
        errors.add(:base, 'Line Items present')
        throw :abort
      end
    end
  end
  