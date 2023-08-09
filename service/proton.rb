module Service
  class Proton
    def proton_natpmpc(proton_gateway)
      `timeout 5 natpmpc -g #{proton_gateway} -a 0 0 udp 60 && natpmpc -g #{proton_gateway} -a 0 0 tcp 60`
    end

    def parse_proton_response(proton_response)
      if !proton_response.nil? && proton_response.include?("Mapped public port")
        markerstring0 = "port "
        markerstring1 = " protocol"

        proton_response[/#{markerstring0}(.*?)#{markerstring1}/m, 1].to_i
      end
    end
  end
end
