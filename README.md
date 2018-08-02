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

To get started, choose a namespace for your data models, which will help to avoid conflicts with other models and applications:

```
db = Triple.new(namespace: 'MyProject')
```
