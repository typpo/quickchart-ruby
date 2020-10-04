require 'json'
require 'net/http'
require 'rubygems'
require 'uri'

class QuickChart
  attr_accessor :config, :width, :height, :background_color, :device_pixel_ratio, :format, :key

  def initialize(config, width: 500, height: 300, background_color: '#ffffff', device_pixel_ratio: 1.0, format: 'png', key: nil)
    @config = config
    @width = width
    @height = height
    @background_color = background_color
    @device_pixel_ratio = device_pixel_ratio
    @format = format
    @key = key
  end

  def get_url
    params = {
      c: @config.is_a?(String) ? @config : @config.to_json,
      w: @width,
      h: @height,
      bkg: @background_color,
      devicePixelRatio: @device_pixel_ratio,
      f: @format,
    }
    if @key
      params['key'] = @key
    end

    encoded = URI.encode_www_form(params)
    return 'https://quickchart.io/chart?%s' % encoded
  end

  def _http_post(path)
    spec = Gem.loaded_specs["quickchart"]
    version = if spec then spec.version.to_s else 'unknown' end
    request_headers = {"user-agent" => "quickchart-ruby/%s" % version}

    params = {
      c: @config.is_a?(String) ? @config : @config.to_json,
      w: @width,
      h: @height,
      bkg: @background_color,
      devicePixelRatio: @device_pixel_ratio,
      f: @format,
    }
    if @key
      params['key'] = @key
    end

    uri = URI('https://quickchart.io%s' % path)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    req.body = params.to_json

    return https.request(req)
  end

  def get_short_url
    res = _http_post("/chart/create")
    if (200..300).cover? res.code.to_i
      return JSON.parse(res.body)['url']
    else
      raise 'Request error: %s' % res.body
    end
  end

  def to_blob
    res = _http_post("/chart")
    return res.body
  end

  def to_file(path)
    data = to_blob
    File.open(path, "wb") {
      |path| path.puts data
    }
  end
end
