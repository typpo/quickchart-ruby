require '../lib/quickchart.rb'

qc =
  QuickChart.new(
    {
      type: 'bar',
      data: {
        labels: ['Hello world', 'Test'],
        datasets: [{ label: 'Foo', data: [1, 2] }]
      }
    },
    width: 600, height: 300, device_pixel_ratio: 2.0
  )

puts qc.get_short_url
# https://quickchart.io/chart/render/f-20e74197-3169-476a-a8af-4c2e58d6f0ac
