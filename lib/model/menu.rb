class Menu
  def welcome
    input = TTY::Prompt.new
    res = input.select("Choose how you would like to look up Restaurants, or exit to exit.\n", %w[ZipCode State exit])
    case res
    when 'State'
      print_restaurant_state
    when 'ZipCode'
      print_restaurant_zip
    when 'exit'
      exit
    end
  end

  def print_restaurant_state
    state = TTY::Prompt.new
    get_state = state.ask("\nEnter the 2 State digits:", required: true) do |q|
      q.modify :remove
      q.validate(/[a-z]{2}/i, 'Invalid input. must be two letters')
    end
    size = TTY::Prompt.new
    puts "\e[2J\e[f"
    get_size = size.slider("\nAmount of results you wish to see:".bold, min: 1, max: 20, step: 1, default: 5)
    RestaurantAPI.new(get_state, get_size).get_state_or_zip('state')
    @options = []
    Restaurant.all.select do |restaurant|
      @options << "#{restaurant.name} located at #{restaurant.address['formatted']}.\n"
    end
    if @options.empty?
      puts "We couldn't locate any restaurants with that parameter, please try again."
      print_restaurant_state
    end
    rest = TTY::Prompt.new
    get_rest_info = rest.multi_select(
      "\nSelect the Restaurant you would like to see more details on:\n\n",
      @options,
      min: 1,
      max: 1,
      require: true,
      per_page: 10
    )
    print_review(get_rest_info)
  end

  def print_restaurant_zip
    zip = TTY::Prompt.new
    get_zip = zip.ask("\nEnter the 5 digits ZipCode:", required: true) do |q|
      q.modify :remove
      q.validate(/^\d{5}(-\d{4})?$/, "Invalid input. must be 5 numbers\n")
    end
    size = TTY::Prompt.new
    puts "\e[2J\e[f"
    get_size = size.slider("\nAmount of results you wish to see:".bold, min: 1, max: 20, step: 1, default: 5)
    RestaurantAPI.new(get_zip, get_size).get_state_or_zip('zip_code')
    @options = []
    Restaurant.all.select do |restaurant|
      @options << "#{restaurant.name} located at #{restaurant.address['formatted']}.\n"
    end
    if @options.empty?
      puts "We couldn't locate any restaurants with that parameter, please try again."
      puts "Chances are, that location isn't updated in our database yet!\n"
      print_restaurant_zip
    end
    rest = TTY::Prompt.new
    get_rest_info = rest.multi_select(
      "\nSelect the Restaurant you would like to see more details on:\n\n",
      @options,
      min: 1,
      max: 1,
      require: true,
      per_page: 10
    )
    print_review(get_rest_info)
  end

  def print_review(input)
    Restaurant.all.clear
    puts "We're working on your request! we got our best man on it!.\n".bold.green
    params = {
      q: input.to_s,
      api_key: '79eb4d5a85e83cd0d3889c559d1d9c21718675646ee3211f4625e6e8728d3eee'
    }
    client = GoogleSearchResults.new(params)
    knowledge_graph = client.get_hash[:knowledge_graph]
    puts "\e[2J\e[f"
    if !knowledge_graph.nil?
      case knowledge_graph[:order]
      when nil
        puts(
          "\nTitle: #{knowledge_graph[:title]} is located at #{knowledge_graph[:address]}",
          "\nType: #{knowledge_graph[:type]}.",
          "\nRating: #{knowledge_graph[:rating]}.".bold.green,
          "\nReview Count:#{knowledge_graph[:review_count]}.".bold.green
        )
      else
        puts(
          "\nTitle: #{knowledge_graph[:title]} is located at #{knowledge_graph[:address]}",
          "\nType: #{knowledge_graph[:type]}.",
          "\nRating: #{knowledge_graph[:rating]}.".bold.red,
          "\nReview Count:#{knowledge_graph[:review_count]}.".bold.red,
          "\nIf you feel like it, you can find #{knowledge_graph[:title]} in any of these platforms:\n",
          "#{knowledge_graph[:order]}\n".bold.blue
        )
      end
    else
      puts "Sorry, couldn't fetch any results. perhaps we try again?\n\n"
    end
    sleep(1)
    continue = TTY::Prompt.new
    to_continue = continue.select('What would you like to do next?', 'Look up another Restaurant', 'Restart the program', 'exit')
    case to_continue
    when 'Look up another Restaurant'
      look_up = TTY::Prompt.new
      updated_choices = @options
      get_look_up = look_up.multi_select(
        "\nSelect the Restaurant you would like to see more details on:\n\n",
        updated_choices,
        min: 1,
        max: 1,
        require: true,
        per_page: 10
      )
      print_review(get_look_up)
    when 'Restart the program'
      puts "\e[2J\e[f"
      welcome
    else
      exit
    end
  end

  def run
    puts "\e[2J\e[f"
    sleep(0.2)
    puts "Hello! welcome to Your favorite Restaraunt locator.\n".blue.bold
    sleep(0.7)
    puts "We're getting things ready, just a second please...\n\n".blue.bold
    sleep(1.5)
    welcome
  end
end
