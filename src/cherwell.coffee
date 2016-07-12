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
  username: 'example'
  password: 'example'
  ssl: true

config.ssl = true if process.env.HUBOT_CHERWELL_SSL
config.host = process.env.HUBOT_CHERWELL_HOST if process.env.HUBOT_CHERWELL_HOST
config.username = process.env.HUBOT_CHERWELL_USER if process.env.HUBOT_CHERWELL_USER
config.password = process.env.HUBOT_CHERWELL_PASS if process.env.HUBOT_CHERWELL_PASS

unless config.username == "example"
  cher.connect config

GetBusinessObjectByPublicId = (robot, msg, args) ->

  # robot.logger.info "searchByObjectTypes: sending request for #{keyword}"
  cher.GetBusinessObjectByPublicId args, (err, res) ->
    if err
      msgout = "#{moduledesc}: error"
      robot.logger.info "#{msgout} (#{err}) [#{msg.envelope.user.name}]"
      return robot.send {room: msg.envelope.user.name}, "#{msgout}, check hubot log for details"

    if res is null
      msgout = "#{moduledesc}: no searchByObjectTypes results for `#{JSON.stringify(args)}`"
      robot.logger.info "#{msgout} [#{msg.envelope.user.name}]"
      return msg.reply msgout
      
    r = []
    r.push "Desc: #{ShortDescription}"
    r.push "Created: #{CreatedDateTime} / LastModified: #{LastModifiedDateTime} / Closed: #{ClosedDateTime}"
    r.push "Svc/cat/subcat: #{Service} / #{res.Category} / #{res.Subcategory}"
    r.push "Owned by: #{OwnedBy} (#{res.OwnByTeam})"
    out = r.join "\n"

    msgout = "#{moduledesc}: `#{res.length} results` ```#{out}```"
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

