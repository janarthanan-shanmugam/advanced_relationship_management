  module AdvancedRelationshipManagement
    module RecursiveRelationships
      extend ActiveSupport::Concern
  
      included do
        after_initialize :setup_recursive_relationships
        after_create :clear_cache
        after_update :clear_cache
        after_destroy :clear_cache
      end
  
      def setup_recursive_relationships
        return if self.class.reflect_on_association(:children) && self.class.reflect_on_association(:parent)
  
        parent_column = self.class.parent_column_name
        self.class.setup_relationships(parent_column)
      end
  
      def descendants(*scopes)
        if AdvancedRelationshipManagement.enable_caching
          Rails.cache.fetch([self, "descendants"] + scopes) { fetch_descendants(*scopes) }
        else
          fetch_descendants(*scopes)
        end
      end
  
      def fetch_descendants(*scopes)
        relation = self.class.find_by_sql([<<-SQL, id])
          WITH RECURSIVE descendants_cte AS (
            SELECT *
            FROM #{self.class.table_name}
            WHERE #{self.class.child_column_name} = ?
            UNION ALL
            SELECT #{self.class.table_name}.*
            FROM #{self.class.table_name}
            INNER JOIN descendants_cte ON descendants_cte.#{self.class.child_column_name} = #{self.class.table_name}.#{self.class.parent_column_name}
          )
          SELECT *
          FROM descendants_cte
        SQL
  
        scopes.each do |scope|
          relation = relation.public_send(scope) if scope.is_a?(Symbol)
          relation = relation.merge(scope) if scope.is_a?(ActiveRecord::Relation)
        end
  
        relation
      end
  
      def ancestors
        if AdvancedRelationshipManagement.enable_caching
          Rails.cache.fetch([self, "ancestors"]) { fetch_ancestors }
        else
          fetch_ancestors
        end
      end
  
      def fetch_ancestors
        all_ancestors = []
        ActiveRecord::Base.silence do
          current_node = self
          while current_node.parent
            all_ancestors << current_node.parent
            current_node = current_node.parent
          end
        end
        all_ancestors
      end
  
      def depth_of_descendants
        descendants_with_depth = {}
        descendants.each do |descendant|
          descendants_with_depth[descendant] = depth(descendant)
        end
        descendants_with_depth
      end
  
      def depth_of_ancestors
        ancestors_with_depth = {}
        ancestors.each do |ancestor|
          ancestors_with_depth[ancestor] = depth(ancestor)
        end
        ancestors_with_depth
      end
  
      def depth(node)
        node.ancestors.size
      end
  
      private
  
      def clear_cache
        Rails.cache.delete([self, "descendants"])
        Rails.cache.delete([self, "ancestors"])
      end
    end
  end
  