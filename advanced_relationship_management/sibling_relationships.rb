module AdvancedRelationshipManagement
    module SiblingRelationships
      extend ActiveSupport::Concern
  
      def siblings
        return [] if parent.nil?
  
        parent.children.where.not(id: self.id)
      end
    end
  end
  