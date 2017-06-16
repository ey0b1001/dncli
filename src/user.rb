require_relative 'common'
require 'nokogiri'

def get_user_account(domain, id)
  token = get_token_with_exit_if_err(domain)
  res = get('https://' + domain + '/api/v1/accounts/' + id.to_s + '?access_token=' + token)
  if res.code == '200'
    json = JSON.parse(res.body)
    puts '================================================================================'
    name_line = json['display_name'] + ' (' + json['acct'] + ':' + json['id'].to_s + ')'
    if json['locked']
      name_line = name_line + ' <鍵>'
    end
    puts name_line
    puts 'toot : ' + json['statuses_count'].to_s + ' followers : ' +
      json['followers_count'].to_s + ' following : ' +
      json['following_count'].to_s
    puts ''
    puts Nokogiri::HTML(json['note']).content
    puts '================================================================================'
  else
    puts 'some error has occured, with code ' + res.code
  end
end

module API
  def self.user(domain, id)
    get_user_account(domain, id)
  end
end
