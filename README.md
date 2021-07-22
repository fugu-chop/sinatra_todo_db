# Sinatra To-Do App
A repo to contain a personal task manager using Sinatra, backed by Postgres. This is the [same application as found here](https://github.com/fugu-chop/sinatra_todo), however instead of using the browser session to keep track of user state, we are using a Postgres database to keep track.

### Basic Overview
This is a Sinatra based To-Do app that allows users to create multiple lists, where each list can contain multiple to-do items, all through the web browser. Both individual to-do items and lists can be created, renamed and deleted, with some validation built in (i.e. preventing duplicate lists, duplicate to-do items on the same list, empty names).

A layout was used to reduce the number of `.erb` view templates required. Most of the styling was provided as a CSS template file. 

### How to run
This app can be found here: https://todo-list-db-dw.herokuapp.com/

To get it running locally:
1. Clone the repo locally
2. Make sure you have the `bundle` gem installed.
2. Run `bundle install` in your CLI
3. Run `ruby todo.rb` in your CLI
4. Visit `http://localhost:4567` in your web browser
5. If you need to reset the app (i.e. delete all information), please delete the associated cookie through your browser.

### Design Choices
What was before handled simply by direct interaction with the `session` hash provided by Sinatra is now extracted into a separate class, `DatabasePersistence`. Routes are still currently handled outside of this class, in the `main` scope.

This application is mostly a swap from using the `session` hash to using a database. Data structures were retained in the interest of making the transition easy. The overall code is significantly easier to reason about - SQL statements are far easier and more uniform than array/hash manipulation across different methods.

I also moved some methods from the application code to the database code - SQL feels more efficient in respect of aggregating data, and reducing the number of queries that need to be made (i.e. reducing `n+1` queries) when fetching to-dos for display - there is now only a single database query, instead of `n+1` queries, where `n` is the number of lists or to-dos being displayed.

The trade-off is that there is some duplication in respect of the SQL being executed. I'm happy with this for now - I'm aware that there are other frameworks/tools that work at a higher level of abstraction to conditionally add statements to SQL queries, but I'm not going to focus on those for now.
