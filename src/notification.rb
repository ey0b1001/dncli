require_relative 'common'
require 'nokogiri'

def print_notification(js)
  case js['type']
  when 'mention'
    puts '[mention]'
  when 'favourite'
    puts '[favourited]'
  when 'reblog'
    puts '[BT]'
  when 'follow'
    puts '[followed]'
  end
  if js['type'] != 'follow'
    puts
    puts '----------------------------------------'
    puts
    puts '[' + js['status']['id'].to_s + ']' + ' | ' + time_to_jp_str(js['status']['created_at'])
    puts
    puts js['status']['account']['display_name'] +
      ' (' + js['status']['account']['acct'] + ':' +
      js['status']['account']['id'].to_s + ')'
    puts
    puts Nokogiri::HTML(js['status']['content']).content
  end
end

def print_notifier_name_line(js)
  name_line = js['account']['display_name'] +
    ' (' + js['account']['acct'] + ':' + js['account']['id'].to_s + ')'
  if js['account']['locked']
    name_line = name_line + ' <鍵>'
  end
  puts '[' + js['id'].to_s + ']' + ' | ' + time_to_jp_str(js['created_at'])
  puts '--------------------------------------------------------------------------------'
  puts name_line
  puts
end

def get_notification(domain)
  token = get_token_with_exit_if_err(domain)
  res = get('https://' + domain + '/api/v1/notifications?access_token=' + token)
  if res.code == '200'
    json = JSON.parse(res.body).reverse!
    puts '================================================================================'
    for js in json do
      print_notifier_name_line(js)
      print_notification(js)
      puts '================================================================================'
    end
  else
    puts 'some error has occured, with code ' + res.code
  end
end

module API
  def self.notification(domain)
    get_notification(domain)
  end
end
