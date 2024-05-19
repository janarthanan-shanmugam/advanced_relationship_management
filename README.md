# AdvancedRelationshipManagement

`AdvancedRelationshipManagement` is a Ruby on Rails gem designed to enhance the management of complex relationships between Active Record models. This includes support for hierarchical and recursive relationships, advanced scoping, and relationship visualizations.

## Features

- **Recursive Relationships**: Define and query recursive relationships (e.g., organizational hierarchies).
- **Advanced Scoping**: Define advanced scopes for querying related records.
- **Relationship Visualizations**: Visualize relationships using graph diagrams.
- **Cycle Detection and Prevention**: Ensure that there are no cycles in the relationships and prevent cycles when adding new records.
- **Sibling Relationships**: Fetch siblings of a record.
- **Ancestor and Descendant Count**: Get the count of ancestors and descendants.
- **Path to Root**: Get the path from the current node to the root node.
- **BFS and DFS Traversal**: Traverse the hierarchy using Breadth-First Search (BFS) and Depth-First Search (DFS).
- **Custom Scopes**: Define custom scopes for relationships.
- **Lazy Loading**: Implement lazy loading for large hierarchical structures to improve performance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'advanced_relationship_management', '~> 1.0.0'
```ruby

And then execute:
```ruby
bundle install
```ruby
