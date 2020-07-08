class RestaurantAPI
  attr_accessor :input, :size

  def initialize(input, size)
    @input = input
    @size = size
  end

  def get_state
    res = HTTParty.get(
      "https://us-restaurant-menus.p.rapidapi.com/restaurants/state/#{input}?size=#{size}",
      headers: {
        'X-RapidAPI-Host' => 'us-restaurant-menus.p.rapidapi.com',
        'X-RapidAPI-Key' => '4ef111b107msh70b94b1aa826703p1d13cajsnf32b82bc0a41'
      }
    )
    res['result']['data'].each do |index|
      Restaurant.new(index['address'], index['restaurant_name'])
    end
  end

  def get_zipcode
    res = HTTParty.get(
      "https://us-restaurant-menus.p.rapidapi.com/restaurants/zip_code/#{input}?size=#{size}",
      headers: {
        'X-RapidAPI-Host' => 'us-restaurant-menus.p.rapidapi.com',
        'X-RapidAPI-Key' => '4ef111b107msh70b94b1aa826703p1d13cajsnf32b82bc0a41'
      }
    )
    res['result']['data'].each do |index|
      Restaurant.new(index['address'], index['restaurant_name'])
    end
  end
end
