module AdvancedRelationshipManagement
    module Counts
      extend ActiveSupport::Concern
  
      def ancestor_count
        ancestors.size
      end
  
      def descendant_count
        descendants.size
      end
    end
  end
  