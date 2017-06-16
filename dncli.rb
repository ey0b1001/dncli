#!/usr/bin/env ruby
require './src/usage'
require './src/toot'
require './src/verify'
require './src/user'
require './src/timeline'
require './src/notification'
require './src/follow'
require './src/unfollow'
require './src/favourite'
require './src/unfavourite'
require './src/reblog'
require './src/unreblog'

def exit_if_invalid_args(num)
  if ARGV.length <= num
    show_usage
    exit 0
  end
end

def exec_api(lambda, n)
  exit_if_invalid_args(n)
  lambda.call
end

def exec_streaming_api(lambda, n)
  exit_if_invalid_args(n)
  loop do
    lambda.call
    sleep(ARGV[2].to_f)
  end
end

def get_timeline
  case ARGV[0]
  when 'htl'
    exec_api -> { API.htl(ARGV[1]) }, 1
  when 'ltl'
    exec_api -> { API.ltl(ARGV[1]) }, 1
  when 'ftl'
    exec_api -> { API.ftl(ARGV[1]) }, 1
  when 'shtl'
      exec_streaming_api -> { API.htl(ARGV[1]) }, 2
  when 'sltl'
      exec_streaming_api -> { API.ltl(ARGV[1]) }, 2
  when 'sftl'
      exec_streaming_api -> { API.ftl(ARGV[1]) }, 2
  end
end

def get_user_status
  case ARGV[0]
  when 'user'
    exec_api -> { API.user(ARGV[1], ARGV[2]) }, 2
  when 'notify'
    exec_api -> { API.notification(ARGV[1]) }, 1
  end
end

def do_user_action
  case ARGV[0]
  when 'follow'
    exec_api -> { API.follow(ARGV[1], ARGV[2]) }, 2
  when 'unfollow'
    exec_api -> { API.unfollow(ARGV[1], ARGV[2]) }, 2
  when 'fav'
    exec_api -> { API.favourite(ARGV[1], ARGV[2]) }, 2
  when 'unfav'
    exec_api -> { API.unfavourite(ARGV[1], ARGV[2]) }, 2
  when 'bt'
    exec_api -> { API.reblog(ARGV[1], ARGV[2]) }, 2
  when 'unbt'
    exec_api -> { API.unreblog(ARGV[1], ARGV[2]) }, 2
  end
end

def talk_with_someone
  case ARGV[0]
  when 'toot'
    exec_api -> { API.toot(ARGV[1], ARGV[2]) }, 2
  when 'vtoot'
    exec_api -> { API.vtoot(ARGV[1], ARGV[2], ARGV[3]) }, 3
  when 'reply'
    exec_api -> { API.reply(ARGV[1], ARGV[2], ARGV[3]) }, 3
  when 'vreply'
    exec_api -> { API.vreply(ARGV[1], ARGV[2], ARGV[3], ARGV[4]) }, 4
  end
end

def execute_mastodon
  exit_if_invalid_args(0)
  if ARGV[0] == 'verify'
    API.verify
  end
  get_timeline
  get_user_status
  do_user_action
  talk_with_someone
end

execute_mastodon
