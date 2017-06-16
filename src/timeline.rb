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

def update_status_public(domain)
  token = get_token_with_exit_if_err(domain)
  res = get('https://' + domain + '/api/v1/timelines/public?access_token=' + token)
  if res.code == '200'
    print_status(res)
  else
    puts 'some error has occured, with code ' + res.code
  end
end

def update_status_local(domain)
  token = get_token_with_exit_if_err(domain)
  res = get('https://' + domain + '/api/v1/timelines/public?access_token=' + token + '&local=true')
  if res.code == '200'
    print_status(res)
  else
    puts 'some error has occured, with code ' + res.code
  end
end

module API
  def self.ltl(domain)
    update_status_local(domain)
  end
  def self.ftl(domain)
    update_status_public(domain)
  end
  def self.htl(domain)
    update_status_home(domain)
  end
end
