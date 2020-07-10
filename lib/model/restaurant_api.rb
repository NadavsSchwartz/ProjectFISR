class RestaurantAPI
  attr_accessor :data, :review_data

  def initialize
    @data = []
    @review_data = []
  end

  def set_url_by_state(input, size)
    @url = "https://us-restaurant-menus.p.rapidapi.com/restaurants/state/#{input}?size=#{size}"
  end

  def set_url_by_zip(input, size)
    @url = "https://us-restaurant-menus.p.rapidapi.com/restaurants/zip_code/#{input}?size=#{size}"
  end

  def get_data
    @data = HTTParty.get(
      @url,
      headers: {
        'X-RapidAPI-Host' => 'us-restaurant-menus.p.rapidapi.com',
        'X-RapidAPI-Key' => ENV['PUBLIC_API']
      }
    )
    if @data.empty?
      puts 'We have encountered an error.'
      puts 'Please restart the program and try again.'
      exit
    end
  end

  def get_review_data(user_decision)
    puts "We're working on your request! we got our best man on it!.\n".bold.green
    params = {
      q: user_decision.to_s,
      api_key: ENV['GOOGLE_API']
    }
    client = GoogleSearchResults.new(params)
    @review_data = client.get_hash[:knowledge_graph]
  end
end
