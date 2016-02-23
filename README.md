![General Assembly Logo](http://i.imgur.com/ke8USTq.png)

# ActiveRecord Migration Constraints and Model Validations

## Instructions

Fork and clone this repository, and then run `bundle install`.

## Objectives

By the end of this lesson, students should be able to:

-   Explain the relationship between constraints and validations
-   Use constraints to help enforce data integrity
-   Use validations to help enforce data integrity

## Introduction

A company's data can sometimes be its most valuable asset,
 even more so than code or employees.
There are several different places where data integrity
 can be maintained within an application, including:

-   within the database itself
-   on the client-side (implemented in JavaScript)
-   in the controllers

However, each of these approaches has advantages and disadvantages.

| Location   | Pro                                                                                         | Con                                                           |
|:-----------|:--------------------------------------------------------------------------------------------|:--------------------------------------------------------------|
| Database   | Useful if multiple apps use the same DB. Sometimes faster than other approaches.            | Implementation depends on the specific DB you use.            |
| Client     | Independent of our back-end Implementation. Quick feedback for users.                       | Unreliable on its own, and can be circumvented.               |
| Controller | Within the app, so it can't be circumvented. In Ruby, so it's independent of our DB choice. | Difficult to test and maintain. Controllers should be sparse! |

Rails's perspective is that the best places for dealing with data integrity are
 in migrations and in the model,
 since they have all of the advantages of controller validation
 but none of the disadvantages.

> Except strong parameters -
> that kind of validation is conventionally done in the controller.

Let's look at some ways ActiveRecord helps us to maintain data integrity.

## Migration Constraints

As you may recall from the SQL material, a **constraint**
 is a restriction on the data allowed in a table column (or columns).
We've already seen a few of these in previous projects' migration files:

```ruby
class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.integer :population
      t.string :language

      t.timestamps null: false # `null: false` is a constraint
    end
  end
end
```

Different SQL implementations use a wide variety of different constraints;
 ActiveRecord supports some of these, but not all.
The most important ones that it _does_ support are:

-   **`null: false`**

    Equivalent to the `NOT NULL` constraint in SQL.
    This prevents the database from saving a row
     without a value in that particular column into the database.

    **EXAMPLE :**
    Suppose I want to ensure that every country entered has a name -
     blank names are forbidden.
    In the migration file for Countries, I can write:

    ```ruby
    class CreateCountries < ActiveRecord::Migration
      def change
        create_table :countries do |t|
          t.string :name, null: false       # added ', null: false'
          t.integer :population
          t.string :language

          t.timestamps null: false
        end
      end
    end
    ```

    If I run this migation, and then open up the Rails Console,
     I find that I am unable to `create` new Countries
     without specifying names for them.

-   **`unique: true` / `index: {unique: true}`**

    A uniqueness constraint.
    This can be used to define a single column as having only unique values,
     or to specify that certain _combinations of column values_ must be unique.

    **EXAMPLE :**
    Consider a second model, Person.
    Suppose I want to ensure that each person has a unique phone number,
     and a unique full name (`given_name` + `surname`);
     I might make the following change to the `CreatePeople` migration.

    ```ruby
    class CreatePeople < ActiveRecord::Migration
      def change
        create_table :people do |t|
          t.string :given_name
          t.string :surname
          t.string :phone_number

          t.timestamps null: false
        end

        add_index :people, :phone_number, unique: true
        add_index :people, [:given_name, :surname], unique: true
      end
    end
    ```

    **Be careful**: a `NULL` value never equals anything, including itself,_
     so `NULL` values are always unique.
    This is sometimes desirable,
     but in most cases we'll also want the `null:false` option.

    > **NOTEWORTHY ASIDE**
    >
    > Though it's not a constraint,
    > you should know that `index: <hash>` passes on
    > any parameters given in the hash to the `add_index` method.
    >

    ```ruby
    add_column :people, :phone_number, :string, index: {unique: true}
    # Above and below are equivalent.
    add_column :people, :phone_number, :string
    add_index :people, :phone_number, unique: true
    ```

    > You may also see `index: true` in an add_reference method;
    >  in that context, `index: true` is telling Rails
    >  to create a new index column and to make that the reference.

-   **`foreign_key: true` / `references: {foreign_key: true}`**

      A referential constraint,
       requiring that a row in a "child" table have
       a matching identifier in the "parent" table.

      _As with the uniqueness constraint,_
       _this doesn't prevent null values in the referring column,_
       _so we'll usually want to include the `null:false` option._

      **EXAMPLE :**
      Now that we have 'Country' and 'Person' resources,
       suppose we want to link them together
       through a third resource called 'Citizenship'.
      I run `rails g model Citizenship status:string date_obtained:date`,
       which builds a new model and migration file.
      I can then create two new empty migrations to link all of the tables.

      ```ruby
      class AddPeopleToCitizenships < ActiveRecord::Migration
        def change
          add_reference :citizenships, :person, index: true, foreign_key: true
        end
      end
      ```

      ```ruby
      class AddCountriesToCitizenships < ActiveRecord::Migration
        def change
          add_reference :citizenships, :country, index: true, foreign_key: true
        end
      end
      ```

    > If the '...\_id' column was already added by a previous migration,
    > I could use `add_foreign_key` method instead of `add_reference`
    > to add the foreign key constraint to an existing column.

    Once I add the appropriate methods to the models,
     I can test it in the Rails Console.

    ```ruby
    class Country < ActiveRecord::Base
      has_many :citizenships
      has_many :people, through: :citizenships
    end
    ```

    ```ruby
    class Person < ActiveRecord::Base
      has_many :citizenships
      has_many :countries, through: :citizenships
    end
    ```

    ```ruby
    class Citizenship < ActiveRecord::Base
      belongs_to :country
      belongs_to :person
    end
    ```

### We Do :: ActiveRecord Constraints

In your squads,
 follow the example above and create three new resources
 that have a `has_many ... , through ... ` relationship,
 and add non-null, uniqueness, and foreign key constraints
 to all three via the migration files.

### You Do :: ActiveRecord Constraints

Individually, create two new resources in the same application
 that exhibit a one-to-many (`has_many`/`belongs_to`) relationship.

## Model Validations

`ActiveRecord::Base` provides **validator** methods
 that allow us to perform checks on model properties.
For certain model methods
 (`create`, `create!`, `save`, `save!`, `update`, `update!`),
 if any requested check fails, the model cannot be saved.
There are many more model validation methods
 than there are ways to set constraints in migration files,
 so you'll often see more validation done in models than in migrations.

Let's look at how we might validate the same three things
 that we wanted to validate above: empty values, uniqueness, and references.

-   **Empty Values**

      To prevent empty values we'll use `validates <property>, presence: true`.
      This is a slightly more restrictive check than `null: false`;
       it disallows both empty values (`nil` in Ruby, `NULL` in the database),
       and it also disallows empty strings (for string properties).

      **EXAMPLE :**
      To set an empty-value validator in our Country model, I might write

      ```ruby
      class Country < ActiveRecord::Base
        has_many :citizenships
        has_many :people, through: :citizenships

        validates :name, presence: true
      end
      ```

-   **Uniqueness**

      To ensure that a property is unique,
       we'll use `validates <property>, uniqueness: true`.
      If this is a multi-column uniqueness check,
       we replace the boolean with a hash
       providing a scope for the uniqueness check,
       e.g. `{scope: <other property>}`.

      **EXAMPLE :**
      To set some uniqueness validators in my Person model, I might write

      ```ruby
      class Person < ActiveRecord::Base
        has_many :citizenships
        has_many :countries, through: :citizenships

        validates :phone_number, uniqueness: true
        validates :given_name, uniqueness: {scope: :surname}
        validates :surname, uniqueness: {scope: :given_name}
      end
      ```

-   **References**

      For referential integrity checks,
       we'll use `validates <model>, presence: true`,
       where `<model>` is the symbol we passed to `belongs_to`.

      **EXAMPLE :**
      I want to test that a Citizenship instance refers to
       an instance of Country and an instance of Person.
       I might write the following:

      ```ruby
      class Citizenship < ActiveRecord::Base
        belongs_to :country
        belongs_to :person

        validates :country, presence: true
        validates :person, presence: true
      end
      ```

`ActiveRecord::Base` comes with a slew of other validators we can use,
as well as the mechanisms to create our own custom validators.

## Additional resources

-   [Active Record Migrations - Rails Guides](http://guides.rubyonrails.org/active_record_migrations.html)
-   [Active Record Migrations - api](http://api.rubyonrails.org/classes/ActiveRecord/Migration.html)
-   [Active Record Associations - Rails Guides](http://guides.rubyonrails.org/association_basics.html)
-   [Active Record Associations - api](http://api.rubyonrails.org/files/activerecord/lib/active_record/associations_rb.html)
-   [Active Record Validations](http://guides.rubyonrails.org/active_record_validations.html)
