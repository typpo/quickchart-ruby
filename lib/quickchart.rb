require 'json'
require 'net/http'
require 'rubygems'
require 'uri'

class QuickChart
  attr_accessor :config,
                :width,
                :height,
                :background_color,
                :device_pixel_ratio,
                :format,
                :key,
                :base_url

  def initialize(
    config,
    width: 500,
    height: 300,
    background_color: '#ffffff',
    device_pixel_ratio: 1.0,
    format: 'png',
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

    encoded = URI.encode_www_form(params)
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

    uri = URI("#{@base_url}#{path}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = params.to_json

    https.request(req)
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
