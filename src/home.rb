require_relative 'common'

def update_status_home(domain)
  token = get_token_with_exit_if_err(domain)
  res = get('https://' + domain + '/api/v1/timelines/home?access_token=' + token)
  if res.code == '200'
    print_status(res)
  else
    puts 'some error has occured, with code ' + res.code
  end
end

module API
  def self.htl(domain)
    update_status_home(domain)
  end
end
