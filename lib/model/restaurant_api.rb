class RestaurantAPI
  attr_accessor :input, :size

  def initialize(input, size)
    @input = input
    @size = size
  end

  def get_state_or_zip(method)
    res = HTTParty.get(
      "https://us-restaurant-menus.p.rapidapi.com/restaurants/#{method}/#{input}?size=#{size}",
      headers: {
        'X-RapidAPI-Host' => 'us-restaurant-menus.p.rapidapi.com',
        'X-RapidAPI-Key' => ENV['API']
      }
    )
    res['result']['data'].each do |index|
      Restaurant.new(index['address'], index['restaurant_name'])
    end
  end
end
