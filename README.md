![General Assembly Logo](http://i.imgur.com/ke8USTq.png)

Rails: `has_many through:`
==========================

Now that we understand one-to-many relationships using ActiveRecord's `has_many` and `belongs_to`, we'll look at how to manage many-to-many relationships using the same two macros. The difference is we'll be using the `through` option for `has_many`, creating a join table and supporting model if they do not exist, and using `belongs_to` twice on the join model.

Objectives
----------

* Diagram a many-to-many relationship using an ERD.
* Write a migration for a many-to-many relationship.
* Configure ActiveRecord to manage many-to-many relationships.
* Create associated records using the rails console.

Instructions
------------

Fork and clone this repo. Change into the appropriate directory and update dependencies.

Next, create your database, migrate, and seed. Start your web server.

Follow along with your instructor, closing your laptop if requested.

Exercise: ERDs
--------------

Suppose we have `Person`, `Place`, and `Address`. We want to set up two relationships, a one-to-many relationship between `Person` and `Address`, and a one-to-many relationship between `Place` and `Address`.

Diagram these two relationships using an ERD. You should have three entities and two relationships. Using ActiveRecord, we will be able to access `Place` from `Person` and vice-versa. Draw an additional dotted line to represent this "pseudo"-relationship.

Exercise: Join Table Migration
------------------------------

Generate a migration for `addresses`. `addresses` should have references to both `person` and `place`.

After you generate the migration, inspect it visually and if it looks right, run `rake db:migrate`. Next enter `rails db` and inspect the `addresses` table with `\d addresses`. Do the columns look as you'd expect? Your output should resemble:

```txt
                           Table "public.addresses"
  Column   |  Type   |                       Modifiers
-----------+---------+--------------------------------------------------------
 id        | integer | not null default nextval('addresses_id_seq'::regclass)
 person_id | integer |
 place_id  | integer |
Indexes:
    "addresses_pkey" PRIMARY KEY, btree (id)
    "index_addresses_on_person_id" btree (person_id)
    "index_addresses_on_place_id" btree (place_id)
Foreign-key constraints:
    "fk_rails_82bb5e9003" FOREIGN KEY (place_id) REFERENCES places(id)
    "fk_rails_e760e37e14" FOREIGN KEY (person_id) REFERENCES people(id)
```

If you need to make changes to your migration, run `rake db:rollback`, edit the migration, and re-run `rake db:migrate`. If you get stuck, as a last resort you can nuke and pave:

```txt
rake db:drop db:create db:migrate db:seed
```

Rails: `has_many through:`
--------------------------

Since we are continuing to use `has_many`, the methods that are generated on our models are the same as before. See [ActiveRecord::Associations::ClassMethods documentation](http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html#method-i-has_many) for a complete list.

The difference is that this time, we are associating with a join table that should have an associated join model. To be able to access things as we'd expect, we should include both a `has_many` and `has_many through:` on the source model.

Exercise: Creating Associated Records
-------------------------------------

We need to set up ActiveRecord to handle our many-to-many relationship from `Person` to `Place`. Open `app/models/person.rb` and edit it.

```ruby
class Person < ActiveRecord::Base
  has_many :pets, inverse_of: :person

  has_many :places, through: :addresses
  has_many :addresses
end
```

Where do we include our `inverse_of` option? On the join model. We'll be including two `belongs_to` associations on the join model, so let's hold off on creating `app/models/address.rb`.

Let's open `app/models/place.rb` and edit it.

```ruby
class Place < ActiveRecord::Base
  has_many :people, through: :addresses
  has_many :addresses
end
```

Next, create `app/models/address.rb`.

```ruby
class Address < ActiveRecord::Base
  belongs_to :person, inverse_of: :addresses
  belongs_to :place, inverse_of: :addresses
end
```

Enter `rails db`. Query the `addresses` table. It should be empty.

Exit and then enter `rails console`.

```ruby
jeff = Person.find_by(given_name: "Jeffrey", surname: "Horn")
boston = Place.create!(city: "Boston", state: "MA")
dc = Place.create!(city: "Washington", state: "DC")

jeff.places << dc
jeff.places << boston

jeff.places
jeff.addresses
```

Exit and re-enter `rails db`. Query the `addresses` table, the `people` table, and the `places` table. What do you expect to see? Are your expectations met?

Lab: Creating Associated Records
--------------------------------

Create a model and migration for `developers` and `companies`. `developers` should have a `given_name` and a `surname`. `companies` should have a `name`. Inspect your migration, run `rake db:migrate`, and check the results in `rails db`.

Create a model and migration for `jobs`. `jobs` should reference both a `developer` and a `company`, and have an additional `salary` stored as an integer. Inspect your migration, run `rake db:migrate`, and check the results in `rails db`.

Create a many-to-many relationship between `Developer` and `Company` through `Job`. Test your work by attempting to create a new developer and two new companies associated with that developer through `rails console`. Inspect the results in `rails db`.

Best Practice
-------------

Never use `has_and_belongs_to_many`. Always choose `has_many through:`. It is more expensive to change from the former to latter than to create a simple model and join table from the beginning.

Resources
---------

* [Active Record Associations — Ruby on Rails Guides](http://guides.rubyonrails.org/association_basics.html#choosing-between-has-many-through-and-has-and-belongs-to-many) (bad advice)
* [Why You Don’t Need Has_and_belongs_to_many Relationships « Flatiron School](http://blog.flatironschool.com/why-you-dont-need-has-and-belongs-to-many/) (good advice)
* [has_many :through - Many-to-many Dance-off!](http://blog.hasmanythrough.com/2006/4/20/many-to-many-dance-off)
* [Craic Computing Tech Tips: Migrating from Rails HABTM to has_many :through](http://craiccomputing.blogspot.com/2013/06/migrating-from-rails-habtm-to-hasmany.html)
