require 'net/http'
require 'uri'
require 'crack/json'

module LastFM
  class Connection
    def initialize(key)
      @key = key
    end

    def method_missing(method, *args, &block)
      if method.to_s =~ /^get_(\w+)_from_(\w+)$/
        resource = $2
        method = "get" + $1.gsub('_','').downcase
        response = request(resource, method, *args)
        raise response["message"] if response["error"]
        # return response.first.last.first.last
        return response
      else
        super(method, *args, &block)
      end
    end

    private

    def request(resource, method, *args)
      query = args.first.is_a?(Hash) ? nil : args.shift
      options = args.first.is_a?(Hash) ? args.shift : {}
      options.update({:"#{resource}" => "#{query}"}) if query
      options[:format] = :json

      formatted_options = URI.escape(options.map{|e| "&#{e.first}=#{e.last}"}.join)

      args = "?method=#{resource}.#{method}&api_key=#{@key}#{formatted_options}"

      url = URI.parse(API_URL + "/" + args)
      puts "==========url============="
      puts url
      puts "==========url============="
      response= Net::HTTP.get(url)
      Crack::JSON.parse(response)
    end
  end
end