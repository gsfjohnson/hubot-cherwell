# coffeelint: disable=max_line_length
#
# Description:
#   Interact with Cherwell API.
#
# Dependencies:
#   cheroapjs
#
# Configuration:
#   HUBOT_CHERWELL_HOST [required] - url (e.g. cher.example.com)
#   HUBOT_CHERWELL_USER [required] - api user
#   HUBOT_CHERWELL_PASS [required] - api pass
#   HUBOT_CHERWELL_SSL [optional] - use ssl
#
# Commands:
#   hubot cher help - cherwell commands
#
# Notes:
#
# Author:
#   gfjohnson

cher = require 'cheroapjs'

moduledesc = 'Cherwell'
modulename = 'cher'

config =
  host: 'localhost'
  userId: 'example'
  password: 'example'
  ssl: true

config.ssl = true if process.env.HUBOT_CHERWELL_SSL
config.host = process.env.HUBOT_CHERWELL_HOST if process.env.HUBOT_CHERWELL_HOST
config.userId = process.env.HUBOT_CHERWELL_USERID if process.env.HUBOT_CHERWELL_USERID
config.password = process.env.HUBOT_CHERWELL_PASS if process.env.HUBOT_CHERWELL_PASS

unless config.userId == "example"
  cher.connect config

GetBusinessObjectByPublicId = (robot, msg, args) ->

  # robot.logger.info "searchByObjectTypes: sending request for #{keyword}"
  cher.GetBusinessObjectByPublicId args, (err, res) ->
    if err
      msgout = "#{moduledesc}: error"
      robot.logger.info "#{msgout} (#{err}) [#{msg.envelope.user.name}]"
      return robot.send {room: msg.envelope.user.name}, "#{msgout}, check hubot log for details"

    if res is null or !res.ShortDescription
      msgout = "#{moduledesc}: no result for `#{JSON.stringify(args)}`"
      robot.logger.info "#{msgout} [#{msg.envelope.user.name}]"
      return msg.reply msgout
      
    r = []
    r.push "ShortDesc: #{res.ShortDescription.substring 0, 300}"
    r.push "Created: #{res.CreatedDateTime}"
    r.push "LastModified: #{res.LastModifiedDateTime}"
    r.push "Closed: #{res.ClosedDateTime}"
    r.push "Service: #{res.Service}"
    r.push "Category: #{res.Category} -> #{res.Subcategory}"
    r.push "Owned by: #{res.OwnedBy} (#{res.OwnedByTeam})"
    r.push ""
    r.push "#{res.Description.substring 0, 2000}"
    out = r.join "\n"

    msgout = "#{moduledesc}: ```#{out}```"
    robot.logger.info "#{msgout} [#{msg.envelope.user.name}]"
    return msg.reply msgout


module.exports = (robot) ->

  robot.respond /cher help$/, (msg) ->
    cmds = []
    arr = [
      "#{modulename} incident <id> - show incident"
    ]

    for str in arr
      cmd = str.split " - "
      cmds.push "`#{cmd[0]}` - #{cmd[1]}"

    robot.send {room: msg.message?.user?.name}, cmds.join "\n"

  robot.respond /cher i(?:ncident)? (\d+)$/i, (msg) ->
    id = msg.match[1]

    robot.logger.info "#{moduledesc}: incident search: #{id} [#{msg.envelope.user.name}]"

    args =
      busObPublicId: id
    return GetBusinessObjectByPublicId robot, msg, args

