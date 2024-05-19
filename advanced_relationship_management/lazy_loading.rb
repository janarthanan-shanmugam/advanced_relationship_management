module AdvancedRelationshipManagement
    module LazyLoading
      extend ActiveSupport::Concern
  
      included do
        scope :lazy_load_children, -> { includes(:children) }
        scope :lazy_load_parent, -> { includes(:parent) }
      end
  
      def lazy_descendants
        self.class.lazy_load_children.where("#{self.class.parent_column_name} = ?", self.id)
      end
  
      def lazy_ancestors
        self.class.lazy_load_parent.where("#{self.class.child_column_name} = ?", self.id)
      end
    end
  end
  