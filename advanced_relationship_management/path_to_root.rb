module AdvancedRelationshipManagement
    module PathToRoot
      extend ActiveSupport::Concern
  
      def path_to_root(format: :array, attribute: :id)
        path = []
        current_node = self
        while current_node
          path << current_node
          current_node = current_node.parent
        end
        path.reverse!
  
        case format
        when :array
          path
        when :symbolic
          path.map { |node| node.public_send(attribute) }.join(' -> ')
        when :json
          path.map { |node| { id: node.id, attribute => node.public_send(attribute) } }.to_json
        when :html
          path.map { |node| "<a href='/users/#{node.id}'>#{node.public_send(attribute)}</a>" }.join(' > ')
        when :reverse_symbolic
          path.map { |node| node.public_send(attribute) }.reverse.join(' -> ')
        when :nested_hash
          path.inject(nil) { |acc, node| { id: node.id, attribute => node.public_send(attribute), parent: acc } }
        else
          raise ArgumentError, "Unsupported format: #{format}"
        end
      end
    end
  end
  