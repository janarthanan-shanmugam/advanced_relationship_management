module AdvancedRelationshipManagement
    module FilterScope
      extend ActiveSupport::Concern
  
      module ClassMethods
        def filter_scope(name, scope_block)
          scope name, scope_block
        end
      end
    end
  end
  