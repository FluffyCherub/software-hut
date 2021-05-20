# TeamWorks
## _University of Sheffield Feedback System_

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://git.shefcompsci.org.uk/com3420-2020-21/team22/project)

TeamWorks is an automated system, made for managing student teams as well as 
sending, editing and receiving feedback. It is made with the idea in mind
of reducing the administrative overhead that the staff currently has.

## Features

- Automatic profile creation upon first login(using your University of Sheffield credentials)
- Giving feedback to other students in an intuitive and easy way
- Upload and view _Team Operating Agreements_ and _Team Meeting Records_
- Students have the ability to report problems to members of the staff
- Automatic reminders to let the student know if they have feedback to give
- Archiving students' records for later access(such as feedback and documents)
- Create/Edit/Clone modules with the click of a button
- Manage modules and the users in them(with module specific privileges)
- Create/Manage teams based on the university's guidelines
- Profanity filter to help the staff with reviewing feedback

## Tech

TeamWorks uses a number of open source projects to work properly:

- [JavaScript] - JavaScript is a lightweight, interpreted, object-oriented language
- [Bootstrap v4.5] - Bootstrap is a free and open-source CSS framework directed at responsive,
mobile-first front-end web development.
- [AJAX] - A technique for creating better, faster, and more interactive web applications
- [Chart.js] - Simple yet flexible JavaScript charting
- [jQuery] -  jQuery is a lightweight, "write less, do more", JavaScript library

## Installation

Teamworks requires [Ruby](https://rubyinstaller.org) v2.6.6p146 and [Rails](https://rubyonrails.org) 6.0.3.3 to run.

Run this commands to start the project locally in that order:

```sh
bundle install
```

```sh
whenever --update-crontab
```

```sh
sudo service cron restart
```

To start the PostgreSQL database execute the following command:
```sh
sudo service postgresql start
```
To reset the database and seed again execute the following commands:
```sh
bundle exec rails db:drop
```

```sh
bundle exec rails db:create
```

```sh
bundle exec rails db:migrate
```

```sh
bundle exec rails db:seed
```

You can also execute them all at once:
```sh
bundle exec rails db:drop && 
bundle exec rails db:create && 
bundle exec rails db:migrate && 
bundle exec rails db:seed
```


## Development

You can develop the project locally by changing the code base.

Write unit tests for the code you have written in the _app/spec/_ folder

To run a single test do:

```sh
bundle exec rpsec spec/models/your_test_spec.rb  #This is specific for the models folder. Change if needed.
```

Alternatively, if you want to run all test in the models folder do the following:

```sh
bundle exec rpsec spec/models
```

## License

Proprietary software, no public license

[//]: #

   [JavaScript]:  <https://www.javascript.com/>
   [Bootstrap v4.5]: <https://getbootstrap.com/docs/4.5/getting-started/introduction/>
   [AJAX]: <https://api.jquery.com/category/ajax/>
   [Chart.js]: <https://www.chartjs.org>
   [jQuery]: <http://jquery.com>
