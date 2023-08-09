module Service
  class Qbit
    def qbt_auth_login(config)
      uri = URI("#{config['qbit_addr']}/api/v2/auth/login")
      http = Net::HTTP.new(uri.host, uri.port)

      data = {
        "username": config["qbit_user"],
        "password": config["qbit_pass"],
      }

      body = URI.encode_www_form(data)
      req =  Net::HTTP::Post.new(uri)
      req.add_field "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
      req.body = body

      response = http.request(req)
      response["set-cookie"].split(";")[0]
    rescue StandardError => e
      @logger.error("qbt_auth_login - HTTP Request failed - (#{e.message})")
    end

    def qbt_app_preferences(config, sid)
      uri = URI("#{config['qbit_addr']}/api/v2/app/preferences")
      http = Net::HTTP.new(uri.host, uri.port)

      req = Net::HTTP::Get.new(uri)
      req.add_field "Cookie", sid

      response = http.request(req)

      JSON.parse(response.body)["listen_port"]
    rescue StandardError => e
      @logger.error("qbt_app_preferences - HTTP Request failed - (#{e.message})")
    end

    def qbt_app_set_preferences(config, forwarded_port, sid)
      uri = URI("#{config['qbit_addr']}/api/v2/app/setPreferences")
      http = Net::HTTP.new(uri.host, uri.port)

      data = {
        "json": "{\"listen_port\": #{forwarded_port.to_i}}",
      }

      body = URI.encode_www_form(data)
      req =  Net::HTTP::Post.new(uri)
      req.add_field "Cookie", sid
      req.add_field "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
      req.body = body

      http.request(req)
    rescue StandardError => e
      @logger.error("qbt_app_set_preferences - HTTP Request failed - (#{e.message})")
    end
  end
end
