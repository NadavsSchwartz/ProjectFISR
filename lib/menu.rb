class Menu
  attr_accessor :rest_API

  def initialize # initialize instances for the api class and the restuarant manager where the data being held.
    @manager = RestaurantManager.new
    @rest_API = RestaurantAPI.new
  end

  def run # initiate welcome and the start of the program
    puts "\e[2J\e[f"
    sleep(0.2)
    puts "Hello! welcome to Your favorite Restaraunt locator.\n".blue.bold
    sleep(0.7)
    puts "We're getting things ready, just a second please...\n\n".blue.bold
    sleep(1.5)
    welcome
  end

  def welcome
    input = TTY::Prompt.new # asking for user input
    res = input.select("Choose how you would like to look up Restaurants, or exit.\n", %w[ZipCode State exit])
    case res
    when 'State'
      get_state = get_restaurant_state # getting the state the user wants to check
      get_size = get_restaurant_size # getting the amount of results the user chose
      @rest_API.set_url_by_state(get_state, get_size) # completes the url settings based on user input
    when 'ZipCode'
      get_zip = get_restaurant_zip # getting the zipcode the user wants to check
      get_size = get_restaurant_size # getting the amount of results the user chose
      @rest_API.set_url_by_zip(get_zip, get_size) # completes the url settings based on user input
    when 'exit'
      exit
    end
    @rest_API.get_data # initate the connection with the api based on user input
    @manager.receive_data(@rest_API.data) # initiate the connection with the restaurant manager passing the chosen data from the api
    rest = TTY::Prompt.new
    get_rest_info = rest.multi_select( # collecting user input for the google query
      "\nSelect the Restaurant you would like to see more details on:\n\n",
      @manager.print_options,
      min: 1,
      max: 1,
      require: true,
      per_page: 6
    )
    @rest_API.get_review_data(get_rest_info) # getting the results from the google
    @manager.print_review(@rest_API.review_data) # performs a key check to see if result isn't nil or empty, then print it
    continue # collects user input if to continue or exit
  end

  def get_restaurant_zip # mcollect user desired zipcode parameter
    zip = TTY::Prompt.new
    get_zip = zip.ask("\nEnter the 5 digits ZipCode:", required: true) do |q|
      q.modify :remove
      q.validate(/^\d{5}(-\d{4})?$/, "Invalid input. must be 5 numbers\n")
    end
    get_zip
  end

  def get_restaurant_size # collect user desired result size parameter
    size = TTY::Prompt.new
    puts "\e[2J\e[f"
    get_size = size.slider("\nAmount of results you wish to see:".bold, min: 1, max: 20, step: 1, default: 5)
    get_size
  end

  def get_restaurant_state # collect user desired state parameter
    state = TTY::Prompt.new
    get_state = state.ask("\nEnter the 2 State digits:", required: true) do |q|
      q.modify :remove
      q.validate(/[a-z]{2}/i, 'Invalid input. must be two letters')
    end
    get_state
  end

  def continue # collect user desired input for second menu(to continue or not)
    get_continue = TTY::Prompt.new
    continue = get_continue.select('What would you like to do next?', 'Look up another Restaurant', 'Restart the program', 'send the info to your email', 'exit')
    case continue
    when 'exit'
      exit

    when 'Look up another Restaurant' # collect user input to show more info on new selected restaurant
      puts "\e[2J\e[f"
      look_up = TTY::Prompt.new
      get_look_up = look_up.multi_select(
        "\nSelect the Restaurant you would like to see more details on:\n\n",
        @manager.print_options,
        min: 1,
        max: 1,
        require: true,
        per_page: 6
      )
      @rest_API.get_review_data(get_look_up)
      @manager.print_review(@rest_API.review_data)
      continue
    when 'Restart the program' # restarting the program
      puts "\e[2J\e[f"
      @manager.database.clear
      @manager.print_options.clear
      welcome
    when 'send the info to your email' # send the result to the user email
      new_mail = Email.new
      get_user_email = TTY::Prompt.new
      user_email = get_user_email.ask('What is your email?') { |q| q.validate :email }
      new_mail.user_ia(user_email)
      new_mail.send_email(@rest_API.review_data)
      puts 'Success!, the program will reload in about a second.'.green.bold
      sleep(4.5)
      @manager.database.clear # clear the data in restaruant manager
      @manager.print_options.clear
      welcome
    end
  end
end
