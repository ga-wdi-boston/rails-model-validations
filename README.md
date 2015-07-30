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

Data are valuable assets to web companies, often more so than code or
employees.  This makes data integrity an important aspect of any
companies strategy for success.  We'll look at some ways ActiveRecord
supports data integrity.

## ActiveRecord migrations and constraints

A _constraint_, sometimes called a _table constraint_ or _column
constraint_, in the context of a Relational Database Management System,
is a restriction on the data allowed in a table column or columns.
These constraints help ensure the validity of the data stored.

ActiveRecord supports a limited subset of the constraints available from
most RDBMs. These constraints may be applied in migrations creating or
altering tables, columns, and indices.  Other constraints are frequently
vendor specific and ActiveRecord does not support them directly.  We'll
examine a subset of the supported constraints.

The most important of these is the `null: false` column option, which is
equivalent to the SQL `NOT NULL` constraint. This option disallows
the SQL "empty" value `NULL` from being stored in that column.

A uniqueness constraint is created with the `index: {unique: true}`
column option.  Be careful, a `NULL` value never equals anything,
including itself, so `NULL` values are always unique.  This is sometimes
desirable, but in most cases, we'll also want the `null:false` option.
In some circumstances we'll want a combination of columns to be unique.
In that case we'll use the migration `add_index` method to specify the
columns.

A referential constraint, requiring that a row in a "child" table have a
matching identifier in the "parent" table, is create with the
`foreign_key: true` option to the table `references` method or the
migration `add_reference` method.  As with the uniqueness constraint,
this doesn't prevent null values in the referring column.  We'll usually
want to include the `null:false` option.  If the column was added in an
existing migration, we can use the `add_foreign_key` method to add the
constraint in a new migration.

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
