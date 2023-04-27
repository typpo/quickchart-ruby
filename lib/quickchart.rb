require 'cgi'
require 'json'
require 'net/http'

class QuickChart
  attr_accessor :config,
                :width,
                :height,
                :background_color,
                :device_pixel_ratio,
                :format,
                :version,
                :key,
                :base_url

  def initialize(
    config,
    width: 500,
    height: 300,
    background_color: '#ffffff',
    device_pixel_ratio: 1.0,
    format: 'png',
    version: nil,
    key: nil,
    base_url: 'https://quickchart.io'
  )
    @config = config
    @width = width
    @height = height
    @background_color = background_color
    @device_pixel_ratio = device_pixel_ratio
    @format = format
    @key = key
    @version = version
    @base_url = base_url
  end

  def get_url
    params = {
      c: @config.is_a?(String) ? @config : @config.to_json,
      w: @width,
      h: @height,
      bkg: @background_color,
      devicePixelRatio: @device_pixel_ratio,
      f: @format
    }
    params['key'] = @key if @key
    params['v'] = @version if @version

    encoded = params.to_a.map { |x| "#{x[0]}=#{CGI.escape(x[1].to_s)}" }.join('&')

    "#{@base_url}/chart?#{encoded}"
  end

  def _http_post(path)
    spec = Gem.loaded_specs['quickchart']
    version = spec ? spec.version.to_s : 'unknown'
    request_headers = { 'user-agent' => "quickchart-ruby/#{version}" }

    params = {
      c: @config.is_a?(String) ? @config : @config.to_json,
      w: @width,
      h: @height,
      bkg: @background_color,
      devicePixelRatio: @device_pixel_ratio,
      f: @format
    }
    params['key'] = @key if @key
    params['v'] = @version if @version

    uri = URI("#{@base_url}#{path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.instance_of? URI::HTTPS
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = params.to_json

    http.request(req)
  end

  def get_short_url
    res = _http_post('/chart/create')
    raise "Request error: #{res.body}" unless (200..300).cover? res.code.to_i

    JSON.parse(res.body)['url']
  end

  def to_blob
    res = _http_post('/chart')
    res.body
  end

  def to_file(path)
    data = to_blob
    File.open(path, 'wb') { |path| path.puts data }
  end
end
