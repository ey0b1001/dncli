require_relative 'common'

def update_status(domain, str)
  token = get_token_with_exit_if_err(domain)
  res = post('https://' + domain + '/api/v1/statuses',
    {
      'status'         => str,
    },
    {'Authorization'  => 'Bearer ' + token})
  if res.code == '200'
    puts 'post success'
  else
    puts 'some error has occured, with code ' + res.code
  end
end

def update_status_with_visibility(domain, str, visibility)
  token = get_token_with_exit_if_err(domain)
  res = post('https://' + domain + '/api/v1/statuses',
    {
      'status'         => str,
      'visibility'     => visibility,
    },
    {'Authorization'  => 'Bearer ' + token})
  if res.code == '200'
    puts 'post success'
  else
    puts 'some error has occured, with code ' + res.code
  end
end

def update_reply_status(domain, str, rp_id)
  token = get_token_with_exit_if_err(domain)
  res = post('https://' + domain + '/api/v1/statuses',
    {
      'status'         => str,
      'in_reply_to_id' => rp_id,
    },
    {'Authorization'  => 'Bearer ' + token})
  if res.code == '200'
    puts 'post success'
  else
    puts 'some error has occured, with code ' + res.code
  end
end

def update_reply_status_with_visibility(domain, str, rp_id, visibility)
  token = get_token_with_exit_if_err(domain)
  res = post('https://' + domain + '/api/v1/statuses',
    {
      'status'         => str,
      'in_reply_to_id' => rp_id,
      'visibility'     => visibility,
    },
    {'Authorization'  => 'Bearer ' + token})
  if res.code == '200'
    puts 'post success'
  else
    puts 'some error has occured, with code ' + res.code
  end
end

module API
  def self.toot(domain, str)
    update_status(domain, str)
  end
  def self.vtoot(domain, str, visibility)
    update_status_with_visibility(domain, str, visibility)
  end
  def self.reply(domain, str, rp_id)
    update_reply_status(domain, str, rp_id)
  end
  def self.vreply(domain, str, rp_id, visibility)
    update_reply_status_with_visibility(domain, str, rp_id, visibility)
  end
end
