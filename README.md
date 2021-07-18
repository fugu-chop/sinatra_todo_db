# Sinatra To-Do App
A repo to contain a personal task manager using Sinatra, backed by Postgres. This is the [same application as found here](https://github.com/fugu-chop/sinatra_todo), however instead of using the browser session to keep track of user state, we are using a Postgres database to keep track.

### Basic Overview
This is a Sinatra based To-Do app that allows users to create multiple lists, where each list can contain multiple to-do items, all through the web browser. Both individual to-do items and lists can be created, renamed and deleted, with some validation built in (i.e. preventing duplicate lists, duplicate to-do items on the same list, empty names).

A layout was used to reduce the number of `.erb` view templates required. Most of the styling was provided as a CSS template file. 

### How to run
To get it running locally:
1. Clone the repo locally
2. Make sure you have the `bundle` gem installed.
2. Run `bundle install` in your CLI
3. Run `ruby todo.rb` in your CLI
4. Visit `http://localhost:4567` in your web browser
5. If you need to reset the app (i.e. delete all information), please delete the associated cookie through your browser.

### Design Choices
What was before handled simply by direct interaction with the `session` hash provided by Sinatra is now extracted into a separate class, `SessionPersistence`. Routes are still currently handled outside of this class, in the `main` scope.

### Challenges
