# Description:
#   Race to the bottom.
#
#   Battle it out with your mates to see who is the most
#   important/coolest/sexiest/funniest/smartest of them all solely based on the
#   clearly scientific number of github followers.
#
#   Vanity will check all the users from a specific github team, and display
#   them in order by followers.
#
## Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_TEAM_ID
#
# Commands:
#   hubot vanity me github - list peeps ordered by github followers.
#
# Author:
#   patcon@myplanetdigital

module.exports = (robot) ->

  robot.respond /vanity me github$/i, (msg) ->

    github = require 'octonode'
    client = github.client process.env.HUBOT_GITHUB_TOKEN
    ghteam = client.team process.env.HUBOT_GITHUB_TEAM_ID
    ghteam.members (err, body) ->
      body.forEach (team_member) ->
        ghuser = client.user team_member.login
        ghuser.info (err, body) ->
          follower_count = body.followers
          msg.send "#{team_member.login} : #{follower_count}"
