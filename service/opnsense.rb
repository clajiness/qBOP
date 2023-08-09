module Service
  class Opnsense
    def get_alias_uuid(config)
      uri = URI("#{config['opnsense_interface_addr']}/api/firewall/alias/getAliasUUID/#{config['opnsense_alias_name']}")

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Create Request
      req =  Net::HTTP::Get.new(uri)
      req.basic_auth config["opnsense_api_key"], config["opnsense_api_secret"]

      # Fetch Request
      res = http.request(req)
      JSON.parse(res.body)["uuid"]
    rescue StandardError => e
      @logger.error("get_alias_uuid - HTTP Request failed - (#{e.message})")
    end

    def get_alias_value(config, uuid)
      uri = URI("#{config['opnsense_interface_addr']}/api/firewall/alias/get")

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Create Request
      req =  Net::HTTP::Get.new(uri)
      req.basic_auth config["opnsense_api_key"], config["opnsense_api_secret"]

      # Fetch Request
      res = http.request(req)

      alias_content = JSON.parse(res.body).dig("alias", "aliases", "alias", uuid, "content")
      alias_content.values[0]["value"].to_i
    rescue StandardError => e
      @logger.error("get_alias_value - HTTP Request failed - (#{e.message})")
    end

    def set_alias_value(config, forwarded_port, uuid)
      uri = URI("#{config['opnsense_interface_addr']}/api/firewall/alias/setItem/#{uuid}")

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      body = {"alias": {"content": forwarded_port}}.to_json

      # Create Request
      req =  Net::HTTP::Post.new(uri)
      # Add headers
      req.basic_auth config["opnsense_api_key"], config["opnsense_api_secret"]
      # Add headers
      req.add_field "Content-Type", "application/json; charset=utf-8"
      # Set body
      req.body = body

      # Fetch Request
      http.request(req)
    rescue StandardError => e
      @logger.error("set_alias_value - HTTP Request failed - (#{e.message})")
    end

    def apply_changes(config)
      uri = URI("#{config['opnsense_interface_addr']}/api/firewall/alias/reconfigure")

      # Create client
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Create Request
      req =  Net::HTTP::Post.new(uri)
      # Add headers
      req.basic_auth config["opnsense_api_key"], config["opnsense_api_secret"]

      # Fetch Request
      http.request(req)
    rescue StandardError => e
      @logger.error("apply_changes - HTTP Request failed - (#{e.message})")
    end
  end
end
