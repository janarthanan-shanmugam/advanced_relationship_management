module AdvancedRelationshipManagement
    module Configuration
      extend ActiveSupport::Concern
  
      included do
        mattr_accessor :default_parent_column, :default_child_column, :enable_caching
      end
  
      module ClassMethods
        def configure
          yield self
        end
      end
    end
  end
  
  