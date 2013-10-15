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

sprintf  = require('sprintf').sprintf
github = require 'octonode'

client = github.client process.env.HUBOT_GITHUB_TOKEN

countFollowers = (msg, members, cb) ->
  counts = []

  members.forEach (member) ->
    ghuser = client.user member.login
    ghuser.info (err, body) ->
      user = body

      keptUser =
        followers: user.followers
        username: member.login

      counts.push keptUser
      if counts.length == members.length
        last     = 0
        response = ""
        counts.sort (x, y) ->
          y.followers - x.followers
        counts.forEach (user) ->
          response += sprintf("%3d %-15s\n", user.followers, user.username)
          last = user.followers
        cb response


module.exports = (robot) ->

  robot.respond /vanity me github$/i, (msg) ->

    ghteam = client.team process.env.HUBOT_GITHUB_TEAM_ID
    ghteam.members (err, body) ->
      countFollowers msg, body, (output) ->
        msg.send output
