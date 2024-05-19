module AdvancedRelationshipManagement
    module CycleDetection
      extend ActiveSupport::Concern
  
      included do
        validate :no_cycles
      end
  
      def no_cycles
        if ancestors.include?(self)
          errors.add(:base, "Cycle detected in the hierarchy")
        end
      end
    end
  end
  