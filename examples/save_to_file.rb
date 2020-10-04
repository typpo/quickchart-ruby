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

qc.to_file('/tmp/myfile.png')
