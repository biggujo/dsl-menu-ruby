# dsl-menu-ruby

# Description

MenuBuilder is a DSL-based Ruby library for effortless creation of dynamic user menus in your programs. With a simple API, you can generate menus based on method invocation.

# Used technologies

- Ruby (with DSL implementation);
- `rainbow` gem

# Quick Start

Just do `require` on a file:

```ruby
require "./menu"
```

And paste this below example to get started:

```ruby
# Just some examples
def first; puts "First function"; end
def second; puts "Second function"; end
def third; puts "Third function"; end

# Build
builder = MenuBuilder.new do
  add :second, "My Second Function"
  add_at 0, :first, "My First Function" # Add at zero index
  
  add_submenu "My Submenu" do
    add :third # Add with default name
  end
end

# Get
menu = builder.menu

# Run
runner = MenuRunner.new(menu)
runner.run
```

# Classes

## `MenuItem.new(function, name = nil)`

Represents an a `function` with a `name` alias.

Designed for internal use.

### Instance Variables

- `function` - is either a symbol or a function real name (access: read).
- `name` - an alias for a function in menu (access: read).

## `MenuMenu(name = "Menu")`

Represents a menu object stores all `MenuItem` and other `MenuMenu`.

### Instance Variables

- `name`: The name of the menu (access: read/write).
- `is_submenu`: Indicates whether the menu is a submenu (access: read/write).
- `storage`: An array to store menu items or submenus (access: read).

### Public Methods

#### `add(function, name = nil) -> nil`

Adds a `function` to the storage with a provided `alias`.

#### `add_at(index, function_to_invoke, name = nil) -> nil`

Adds a `function` to the storage with a provided `alias` at index `index`.

#### `add_submenu(menu) -> nil`

Adds a `menu` to the storage as submenu, where `menu` is a `MenuMenu` instance.

#### `remove_at(index) -> TrueClass | FalseClass`

Removes an item from the menu by `index`. Returns `true` on success, otherwise `false`.

#### `remove_by(name) -> TrueClass | FalseClass`

Removes an item from the menu by `name` as String. Returns `true` on success, otherwise `false`.

#### `get_item_index_by_name(name) -> Integer | nil`

Returns an index of an item by the `name`, otherwise `nil` on search failure.

#### `invoke(index) -> TrueClass | FalseClass`

Invokes an item by the `index`. Returns `true` if success, otherwise `false`.

#### `print -> nil`

Prints menu items.

## `MenuRunner(menu)`

Gives an interface to runs the provided `menu`.

### Public Methods

#### `run -> nil`

Runs the provided `menu` in CLI mode.

### Private Methods

#### `print_all -> nil`

Print `menu` items in pretty way.

#### `print_utils -> nil`

Print additional utility menu items to work with menu.

E.g. it prints exit shortcut and shortcuts to enter remove modes.

## MenuBuilder(&init_block)

Provides a way to configure menu in one block with usage of `instance_eval`.

### Instance Variables

- `menu`: The MenuMenu instance (access: read/write).

### Public Methods

#### `modify(&block) -> nil`

Provides a way to modify the `menu` like in `initialize` of the class.

#### `add(function, name = nil) -> nil`

Works exactly like `MenuMenu`'s method.

#### `add_at(index, function, name = nil) -> nil`

Works exactly like `MenuMenu`'s method.

#### `add_submenu(name, &block) -> nil`

Works like `MenuMenu`'s method, but creates a submenu instance with a provided `name` using `&block` first and adds it to menu.

# Examples

# Contributors

# TODO:

- [x] add custom names for items;

- [x] remove_at

- [x] remove_by_name

- [x] add_at

- [ ] add docs

- [x] bugfix/add-at-array-bounds

- [x] feature/messages-about-what-is-happening

- [x] Add proper system "clear"

- [x] Move execute() to MenuExecutioner
