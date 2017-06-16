require_relative 'common'

def favourite_toot(domain, id)
  token = get_token_with_exit_if_err(domain)
  res = post('https://' + domain + '/api/v1/statuses/' + id.to_s + '/favourite',
    {}, {'Authorization'  => 'Bearer ' + token})
  if res.code == '200'
    json = JSON.parse(res.body)
    puts 'faved this toot'
    puts
    print_name_line(json)
    puts Nokogiri::HTML(json['content']).content
    puts
  else
    puts 'some error has occured, with code ' + res.code
  end
end


module API
  def self.favourite(domain, id)
    favourite_toot(domain, id)
  end
end
