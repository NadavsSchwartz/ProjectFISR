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
        'X-RapidAPI-Key' => 'ed0caca792msh55626e3d690cd83p155759jsn28e2714c018d'
      }
    )
    if @data['result']['totalResults'] < 1
      puts 'We have encountered an error. we could not locate any restaurant with your choice.'.red.bold
      puts 'The program is going to reset in a second, please try again.'.red.bold
      sleep(6)
      Menu.new.run
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
