whos-on-call
============

A small sinatra app which plugs into your Pagerduty account and provides a simple dashboard for who is currently on call.

Adding/removing groups
======================

Groups are defined in two places - environment variables, and [server.rb](server.rb). Here is an example of the Rails group, and how it is configured:

```sh
# Environment variables
# TEAM_ONE_PRIMARY is the first schedule group for the "Rails" on-call scenario
TEAM_ONE_PRIMARY=PM7LWKU
# TEAM_ONE_SECONDARY is the group which receives cascade notifications when the primary does not acknowledge.
TEAM_ONE_SECONDARY=PI3UE03
```

```ruby
# server.rb
OnCall.configure do |o|
  o.groups = {
    team_one: [
      # The order here is significant: the first entry is a primary, the second entry is the secondary
      ENV.fetch('TEAM_ONE_PRIMARY'),
      ENV.fetch('TEAM_ONE_SECONDARY')
    ]
  }
end
```

If you want to add a specific colour to your group, you'll also need to add an entry in [our css file](public/global.css)
```css
  section .group.team_one {
    color: #BE80FF;
  }
```

Running locally
===============

To run whos-on-call locally, first rename the ".env.sample" file to ".env". You'll need a Pagerduty API token to make requests (a Pagerduty admin should be able to grant one of these), and set that token as `PAGER_TOKEN` in the ".env" file.

Then, you can use `rackup` to run the application.

Deployment
==========

This application is configured to run on Heroku.
