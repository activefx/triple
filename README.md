# Triple

Create an Sqlite-backed Entity-Attribute-Value Datastore

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'triple'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install triple

## Usage

Before you can use Triple, you must require it in your application:

```ruby
require 'triple'
```

To get started, choose a namespace for your data models, which will help to avoid conflicts with other models and applications. Do not choose a name/constant that is already in use, as the `#teardown` method will later remove that constant.

```
db = Triple.new(namespace: 'MyProject')
```

It is also highly recommended that you provide a path to the Sqlite database you want to use instead of the in memory default:

```
db = Triple.new(namespace: 'MyProject', database: '/path/to/my/sqlite/database.db')
```
