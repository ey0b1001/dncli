require_relative 'common'

def follow_user(domain, id)
  token = get_token_with_exit_if_err(domain)
  res = post('https://' + domain + '/api/v1/accounts/' + id.to_s + '/follow',
    {}, {'Authorization'  => 'Bearer ' + token})
  if res.code == '200'
    json = JSON.parse(res.body)
    puts 'id : ' + json['id'].to_s
    puts 'fllowing : ' + json['following'].to_s
    puts 'blocking : ' + json['blocking'].to_s
    puts 'muting : ' + json['muting'].to_s
    puts 'requested : ' + json['requested'].to_s
    puts 'domain blocking : ' + json['domain_blocking'].to_s
  else
    puts 'some error has occured, with code ' + res.code
  end
end


module API
  def self.follow(domain, id)
    follow_user(domain, id)
  end
end
