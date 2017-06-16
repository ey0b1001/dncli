require_relative 'common'
require 'json'
require 'io/console'

def no_echo_gets(io: STDIN, prompt: nil)
  print prompt unless prompt.nil?
  input = io.noecho &:gets
  input.strip!
  puts ''
  return input
end

def get_account_config
  puts 'domain:'
  url = 'https://' + STDIN.gets.chomp!
  puts 'app name'
  app_name = STDIN.gets.chomp!
  user_id_pre = no_echo_gets prompt: 'email:'
  user_id = no_echo_gets prompt: 'input email again:'
  if user_id != user_id_pre
    puts 'not same email'
    exit 0
  end
  password_pre = no_echo_gets prompt: 'password:'
  password = no_echo_gets prompt: 'input password again:'
  if password != password_pre
    puts 'not same password'
    exit 0
  end
  return url, app_name, user_id, password
end

def create_app(url, app_name)
  res = post(url+'/api/v1/apps',
    {'client_name'   => app_name,
     'redirect_uris' => 'urn:ietf:wg:oauth:2.0:oob',
     'scopes'        => SCOPE})
  if res.code == '200'
    json = JSON.parse(res.body)
    return json['client_id'], json['client_secret']
  else
    puts 'creating app failed'
    p res
    exit 0
  end
end

def oauth_app(url, client_id, client_secret, user_id, password)
  res = post(url+'/oauth/token',
    {'client_id'     => client_id,
     'client_secret' => client_secret,
     'username'      => user_id,
     'password'      => password,
     'scope'         => SCOPE,
     'grant_type'    => 'password'})
  if res.code == '200'
    return JSON.parse(res.body)
  else
    puts 'oauth failed'
    p res
    exit 0
  end
end

module API
  def self.verify
    url, app_name, user_id, password = get_account_config
    client_id, client_secret = create_app(url, app_name)
    json = oauth_app(url, client_id, client_secret, user_id, password)
    File.open(PREFIX + url[url.index('://') + 3 .. -1], 'w') do |f|
      f.puts json['access_token']
    end
  end
end
