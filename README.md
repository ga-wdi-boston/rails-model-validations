![General Assembly Logo](http://i.imgur.com/ke8USTq.png)

# An introduction to ActiveRecord validations and migration constraints

## Instructions

Fork and clone this repository, then bundle install.

## Objectives

By the end of this lesson, students should be able to:

- Explain the relationship between constraints and validations
- Use constraints to help enforce data integrity
- Use validations to help enforce data integrity

## Introduction

A company's data can sometimes be its most valuable asset, even more so than code or employees. There are several different places where data integrity can be maintained within an application, including:
* within the database itself
* on the client-side (implemented in JavaScript)
* in the controllers

However, each of these approaches has advantages and disadvantages.

| Location | Pro     | Con     |
| :------- | :------ | :------ |
| Database | Useful if multiple apps use the same DB. Sometimes faster than other approaches. | Implementation depends on the specific DB you use. |
| Client | Independent of our back-end Implementation. Quick feedback for users. | Unreliable on its own, and can be circumvented. |
| Controller | Within the app, so it can't be circumvented. In Ruby, so independent of our DB choice. | Difficult to test and maintain. Controllers should be sparse! |

Rails's perspective is that the best places for dealing with data integrity are in migrations and in the model, since they have all of the advantages of controller validation but none of the disadvantages.

> Except strong parameters - as you know, that kind of validation is conventionally done in the controller.

Let's look at some ways ActiveRecord helps us to maintain data integrity.

## Validation in Migrations - ActiveRecord Constraints

A **constraint**, sometimes called a _table constraint_ or _columnconstraint_, is a restriction on the data allowed in a table column or columns. We've already seen a few of these in previous projects' migration files:

```ruby
class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :surname
      t.string :given_name
      t.string :gender
      t.string :dob

      t.timestamps null: false   # constraint
    end
  end
end

```

Different SQL implementations feature a wide variety of constraints that they can use; ActiveRecord supports some of these, but not all. The most important ones that it _does_ support are:

* **`null: false`**

  Equivalent to the `NOT NULL` constraint in SQL. This prevents the database from saving a row without a value in that particular column into the database.

  e.g.
  ```ruby
  t.timestamps null: false
  ```

* **`default: <some value>`**

  Sets a default value for a column.

  e.g.
  ```ruby
  t.integer :width, :height, null: false, default: 0
  ```

* **`unique: true` / `index: {unique: true}`**

  A uniqueness constraint. This is mostly used in the context of (a) adding indices to tables that, for whatever reason, don't have them, or (b) creating new custom indices based on properties.
  > Be careful: a `NULL` value never equals anything, including itself, so `NULL` values are always unique.
  <!-- This is sometimes desirable, but in most cases - pretty much any case where we're not adding an index - we'll also want the `null:false` option. -->

  e.g.
  ```ruby
  add_column :pets, :species, :string
  add_index :pets, :species, name: 'species_index', unique: true
  ```

* **`index: <hash>`**

  Passes on any parameters given in the hash to the `add_index` method.

  e.g.
  ```ruby
  add_column :pets, :species, :string, index: {name: 'species_index', unique: true}
  # Or, alternatively
  add_column :pets, :species, :string
  add_index :pets, [:species], name: 'species_index', unique: true
  ```

  > You may also see `index: true` in an add_reference method; in that context, `index: true` is telling Rails to create a new index column and to make that the reference. However, this is the only context in which this will work.

* **`foreign_key: true` / `references: {foreign_key: true}`**

  A referential constraint, requiring that a row in a "child" table have a matching identifier in the "parent" table. , is create with the
  `foreign_key: true` option to the table `references` method or the
  migration `add_reference` method.  

  <!-- >As with the uniqueness constraint, this doesn't prevent null values in the referring column, so we'll usually want to include the `null:false` option. -->

  e.g.
  ```ruby
  add_reference :pets, :owner, index: true, foreign_key: true
  # Or
  add_index :pets, :person_id, unique: true
  add_foreign_key :pets, :people
  ```

  >If the '****\_id' column was already added by a previous migration, we can just use the `add_foreign_key` method to add the constraint to that column in a new migration.

### We Do :: ActiveRecord Constraints

<!--  -->

### You Do :: ActiveRecord Constraints

<!--  -->

## Active Record Validations

ActiveRecord provides validators which are checks on model properties.
If any requested check fails, the model cannot be saved.  We'll use
validations for the same reason we use constraints, to help ensure data
integrity.

To prevent empty values we'll use `validates <property>, presence: true`.
This is a slightly more restrictive check than `null: false`, it
disallows both empty values, `nil` in ruby and `NULL` in the database,
and it also disallows empty strings (for string properties).

To ensure that a property is unique, we'll use `validates <property>,
uniqueness: true`.  If this is a multi-column uniqueness check, we
replace the boolean with a hash providing a scope for the uniqueness
check, e.g. `{scope: <other property>}`.

For referential integrity checks, we'll use `validates <model>,
presence: true`, where `<model>` is the symbol we passed to
`belongs_to`.

There are other validators and mechanisms to create our own.  Let's look
at the Rails Guide for Active Record Validations.

## Additional resources

- [Active Record Migrations - Rails Guides](http://guides.rubyonrails.org/active_record_migrations.html)
- [Active Record Migrations - api](http://api.rubyonrails.org/classes/ActiveRecord/Migration.html)
- [Active Record Associations - Rails Guides](http://guides.rubyonrails.org/association_basics.html)
- [Active Record Associations - api](http://api.rubyonrails.org/files/activerecord/lib/active_record/associations_rb.html)
- [Active Record Validations](http://guides.rubyonrails.org/active_record_validations.html)
