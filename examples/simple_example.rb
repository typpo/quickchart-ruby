require '../lib/quickchart.rb'

qc = QuickChart.new(
  {
    type: "bar",
    data: {
      labels: ["Hello world", "Test"],
      datasets: [{
        label: "Foo",
        data: [1, 2]
      }]
    }
  },
  width: 600,
  height: 300,
  device_pixel_ratio: 2.0,
)

puts qc.get_url
# https://quickchart.io/chart?c=%7B%22type%22%3A%22bar%22%2C%22data%22%3A%7B%22labels%22%3A%5B%22Hello+world%22%2C%22Test%22%5D%2C%22datasets%22%3A%5B%7B%22label%22%3A%22Foo%22%2C%22data%22%3A%5B1%2C2%5D%7D%5D%7D%7D&w=600&h=300&bkg=%23ffffff&devicePixelRatio=2.0&f=png
