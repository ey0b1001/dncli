require 'net/http'
require 'openssl'
require 'nokogiri'

SCOPE = "read write follow"
PREFIX = '.dncli.'

def find_token(domain)
  Dir.glob(PREFIX + '*').each_with_index do |f, i|
    if f[f.index(PREFIX) + 7 .. -1] == domain
      File.open(f, 'r') do |file|
        token = file.read
        token.strip!
        return token
      end
    end
  end
  return nil
end

def time_to_jp_str(time)
  str = time.split('T')
  ymd = str[0]
  hms = str[1]
  str = hms.split(':')
  h = (str[0].to_i + 9)
  if h >= 24
    h -= 24
  end
  h = h.to_s
  return ymd + ' | ' + h + ':' + str[1] + ':' + str[2] + '+0900'
end

def print_name_line(js)
  puts '[' + js['id'].to_s + ']' + ' | ' + time_to_jp_str(js['created_at'])
  puts '--------------------------------------------------------------------------------'
  name_line = js['account']['display_name'] +
    ' (' + js['account']['acct'] + ':' + js['account']['id'].to_s + ')'
  if js['account']['locked']
    name_line = name_line + ' <鍵>'
  end
  puts name_line
  puts''
end

def print_reblog_content(js)
  puts '[' + js['reblog']['id'].to_s + ']' + ' | ' + time_to_jp_str(js['created_at'])
  puts
  name_line = js['reblog']['account']['display_name'] +
    ' (' + js['reblog']['account']['acct'] + ':' +
    js['reblog']['account']['id'].to_s + ')'
  if js['reblog']['account']['locked']
    name_line = name_line + ' <鍵>'
  end
  puts name_line
  puts''
  puts Nokogiri::HTML(js['reblog']['content']).content
end

def print_status(res)
  json = JSON.parse(res.body).reverse!
  puts '================================================================================'
  for js in json do
    print_name_line(js)
    if js['reblog'] != nil
      puts 'RT>'
      puts''
      print_reblog_content(js)
    else
      puts Nokogiri::HTML(js['content']).content
    end
    puts '================================================================================'
  end
end

def get_token_with_exit_if_err(domain)
  token = find_token domain
  if token == nil
    puts 'token not found : domain ' + domain + ' has not registered yet?'
    exit 0
  end
  return token
end

def post(url, post, header = nil)
  url = URI.parse(url)
  req = Net::HTTP::Post.new(url.path)
  if header != nil
    header.each do |key, val|
      req[key] = val
    end
  end
  req.set_form_data(post)
  http = Net::HTTP.new(url.host, url.port)
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.use_ssl = true
  http.start do |h|
    res = h.request(req)
    return res
  end
  return nil
end

def get(url_, header = nil)
  url = URI.parse(url_)
  req = Net::HTTP::Get.new(url_)
  if header != nil
    header.each do |key, val|
      req[key] = val
    end
  end
  http = Net::HTTP.new(url.host, url.port)
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.use_ssl = true
  http.start do |h|
    res = h.request(req)
    return res
  end
  return nil
end
