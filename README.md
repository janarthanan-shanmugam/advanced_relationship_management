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
```

And then execute:
```ruby
bundle install
```
Or install it yourself as:

```ruby
gem install advanced_relationship_management
```

## Usage

To use the AdvancedRelationshipManagement gem, include it in your model and configure the necessary relationships:

### Example Model Configuration
You can configure the relationships using the configure_relationships method:
```ruby
class User < ApplicationRecord
  include AdvancedRelationshipManagement

  parent_column :added_by
  child_column :id
end
```

Alternatively, you can configure the relationships using separate methods for parent and child columns:
```ruby
class User < ApplicationRecord
  include AdvancedRelationshipManagement

  parent_column :added_by
  child_column :id
end
```
### Methods
#### 1. descendants
Fetches all descendant records of the current record. Optionally, you can apply custom scopes to filter the results.
```ruby
user = User.find(1)
descendants = user.descendants
# Applying custom scopes if not needed you can simpley remove that scopes and call user.descendants
recent_descendants = user.descendants(:added_by_parent_recently, :with_role)
```

### Returns:
An array of descendant records.
Example Output:
```ruby
# Assume we have the following users:
# User(id: 1, name: "Root User", added_by: nil)
# User(id: 2, name: "Parent User", added_by: 1)
# User(id: 3, name: "Child User", added_by: 2)

descendants = user.descendants
# => [<User id: 2, name: "Parent User", added_by: 1>, <User id: 3, name: "Child User", added_by: 2>]

recent_descendants = user.descendants(:added_by_parent_recently, :with_role)
# => Apply your custom scopes to filter results.
```

#### 2. ancestors
Fetches all ancestor records of the current record.

Example:
```ruby
user = User.find(3)
ancestors = user.ancestors
```
Returns:
An array of ancestor records.

Example Output:
```ruby
# Assume we have the following users:
# User(id: 1, name: "Root User", added_by: nil)
# User(id: 2, name: "Parent User", added_by: 1)
# User(id: 3, name: "Child User", added_by: 2)

ancestors = user.ancestors
# => [<User id: 2, name: "Parent User", added_by: 1>, <User id: 1, name: "Root User", added_by: nil>]
```

#### 3.depth_of_descendants
Calculates the depth of each descendant relative to the current record.

Example:

```ruby
user = User.find(1)
depths = user.depth_of_descendants
```
Returns:

A hash where the keys are descendant records and the values are their respective depths.

Example Output:
```ruby
depths = user.depth_of_descendants
# => {<User id: 2, name: "Parent User", added_by: 1> => 1, <User id: 3, name: "Child User", added_by: 2> => 2}
```
#### 4. depth_of_ancestors
Calculates the depth of each ancestor relative to the current record.
Example:

```ruby
user = User.find(3)
depths = user.depth_of_ancestors
```
Returns:

A hash where the keys are ancestor records and the values are their respective depths.
```ruby
depths = user.depth_of_ancestors
# => {<User id: 2, name: "Parent User", added_by: 1> => 1, <User id: 1, name: "Root User", added_by: nil> => 2}
```
#### 5.siblings
Fetches all sibling records of the current record.

Example:

```ruby
user = User.find(2)
siblings = user.siblings
```
Returns:

An array of sibling records.
```ruby
# Assume we have the following users:
# User(id: 1, name: "Root User", added_by: nil)
# User(id: 2, name: "Parent User", added_by: 1)
# User(id: 3, name: "Another Child", added_by: 1)
# User(id: 4, name: "Child User", added_by: 2)

siblings = user.siblings
# => [<User id: 3, name: "Another Child", added_by: 1>]
```
#### 6. ancestor_count
Fetches the count of all ancestor records of the current record.

Example:

```ruby
user = User.find(3)
ancestor_count = user.ancestor_count
```
Returns:

An integer representing the count of ancestor records.

Example Output:

```ruby
ancestor_count = user.ancestor_count
# => 2
#### 7. descendant_count
Fetches the count of all descendant records of the current record.

Example:

```ruby
user = User.find(1)
descendant_count = user.descendant_count
Returns:

An integer representing the count of descendant records.

Example Output:

```ruby
descendant_count = user.descendant_count
# => 2
```

#### 7. path_to_root
Fetches the path from the current record to the root record. 
Supports multiple formats: :array, :symbolic, :json, :html, :reverse_symbolic, :nested_hash. You can specify the attribute used for the symbolic path.

Example:

```ruby
user = User.find(3)

# Array format
path_array = user.path_to_root(format: :array)
path_array.each do |node|
  puts "User: #{node.id}, Added by: #{node.added_by}, Created at: #{node.created_at}"
end

# Symbolic format using `id`
path_symbolic_id = user.path_to_root(format: :symbolic, attribute: :id)
puts "Path to root (symbolic format using id):"
puts path_symbolic_id

# Symbolic format using `email`
path_symbolic_email = user.path_to_root(format: :symbolic, attribute: :email)
puts "Path to root (symbolic format using email):"
puts path_symbolic_email

# JSON format using `id`
path_json = user.path_to_root(format: :json, attribute: :id)
puts "Path to root (JSON format):"
puts path_json

# HTML breadcrumb format using `email`
path_html = user.path_to_root(format: :html, attribute: :email)
puts "Path to root (HTML breadcrumb format using email):"
puts path_html

# Reverse symbolic format using `id`
path_reverse_symbolic_id = user.path_to_root(format: :reverse_symbolic, attribute: :id)
puts "Path to root (reverse symbolic format using id):"
puts path_reverse_symbolic_id

# Nested hash format using `email`
path_nested_hash = user.path_to_root(format: :nested_hash, attribute: :email)
puts "Path to root (nested hash format using email):"
puts path_nested_hash
```
Returns:

Depending on the format:
```sh
:array: An array of ancestor records.
:symbolic: A string representing the path.
:json: A JSON string representing the path.
:html: An HTML breadcrumb string.
:reverse_symbolic: A string representing the reversed path.
:nested_hash: A nested hash structure.
```

Example Output:
``` ruby
# Assume we have the following users:
# User(id: 1, name: "Root User", email: "root@example.com", added_by: nil)
# User(id: 2, name: "Parent User", email: "parent@example.com", added_by: 1)
# User(id: 3, name: "Child User", email: "child@example.com", added_by: 2)

# Array format
path_array = user.path_to_root(format: :array)
# => [<User id: 1, name: "Root User", email: "root@example.com", added_by: nil>, <User id: 2, name: "Parent User", email: "parent@example.com", added_by: 1>, <User id: 3, name: "Child User", email: "child@example.com", added_by: 2>]

# Symbolic format using `id`
path_symbolic_id = user.path_to_root(format: :symbolic, attribute: :id)
# => "1 -> 2 -> 3"

# Symbolic format using `email`
path_symbolic_email = user.path_to_root(format: :symbolic, attribute: :email)
# => "root@example.com -> parent@example.com -> child@example.com"

# JSON format using `id`
path_json = user.path_to_root(format: :json, attribute: :id)
# => '[{"id":1,"id":1},{"id":2,"id":2},{"id":3,"id":3}]'

# HTML breadcrumb format using `email`
path_html = user.path_to_root(format: :html, attribute: :email)
# => "<a href='/users/1'>root@example.com</a> > <a href='/users/2'>parent@example.com</a> > <a href='/users/3'>child@example.com</a>"

# Reverse symbolic format using `id`
path_reverse_symbolic_id = user.path_to_root(format: :reverse_symbolic, attribute: :id)
# => "3 -> 2 -> 1"

# Nested hash format using `email`
path_nested_hash = user.path_to_root(format: :nested_hash, attribute: :email)
# => {:id=>1, :email=>"root@example.com", :parent=>{:id=>2, :email=>"parent@example.com", :parent=>

```
### Configuration Methods
**configure_relationships**
Configures the parent and child columns for the model.

**Example:**

```ruby

class User < ApplicationRecord
  include AdvancedRelationshipManagement

  configure_relationships(parent_column: :added_by, child_column: :id)
end
```
**parent_column**
Sets the parent column for the model.


```ruby
class User < ApplicationRecord
  include AdvancedRelationshipManagement

  parent_column :added_by
end
```
**child_column**
Sets the child column for the model.


Example:

```ruby

class User < ApplicationRecord
  include AdvancedRelationshipManagement

  child_column :id
end
```

enable_caching
Enables or disables caching for relationship queries.


```ruby
AdvancedRelationshipManagement.enable_caching(true) # Enable caching
AdvancedRelationshipManagement.enable_caching(false) # Disable caching
enable_caching?
```
Checks if caching is enabled.
```ruby
caching_enabled = AdvancedRelationshipManagement.enable_caching?
Caching
The gem provides caching capabilities to improve performance by storing the results of relationship queries.
```

### Conclusion
The AdvancedRelationshipManagement gem provides a comprehensive solution for managing complex relationships in Ruby on Rails applications. By including this gem and configuring it appropriately, developers can easily handle recursive relationships, advanced scoping, and visualizations, all while maintaining optimal performance through caching.




