module AdvancedRelationshipManagement
    module AdvancedScoping
      extend ActiveSupport::Concern
  
      included do
        scope :roots, -> { where(parent_id: nil) }
        scope :by_depth, ->(depth) { where("depth <= ?", depth) }
  
        def depth
          if AdvancedRelationshipManagement.enable_caching
            Rails.cache.fetch([self, "depth"]) { calculate_depth }
          else
            calculate_depth
          end
        end
  
        def calculate_depth
          ancestors.size
        end
  
        scope :with_min_descendants, ->(min) { select { |record| record.descendants.size >= min } }
      end
    end
  end
  