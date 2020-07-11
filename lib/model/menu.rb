class Menu
  attr_accessor :rest_API

  def welcome
    input = TTY::Prompt.new
    res = input.select("Choose how you would like to look up Restaurants, or exit.\n", %w[ZipCode State exit])
    @rest_API = RestaurantAPI.new
    case res
    when 'State'
      get_state = get_restaurant_state
      get_size = get_restaurant_size
      @rest_API.set_url_by_state(get_state, get_size)
    when 'ZipCode'
      get_zip = get_restaurant_zip
      get_size = get_restaurant_size
      @rest_API.set_url_by_zip(get_zip, get_size)
    when 'exit'
      exit
    end
    @rest_API.get_data
    @manager.receiver(@rest_API.data)
    rest = TTY::Prompt.new
    get_rest_info = rest.multi_select(
      "\nSelect the Restaurant you would like to see more details on:\n\n",
      @manager.outputer,
      min: 1,
      max: 1,
      require: true,
      per_page: 6
    )
    @rest_API.get_review_data(get_rest_info)
    @manager.outputer_review(@rest_API.review_data)
    continue_review
  end

  def get_restaurant_zip
    zip = TTY::Prompt.new
    get_zip = zip.ask("\nEnter the 5 digits ZipCode:", required: true) do |q|
      q.modify :remove
      q.validate(/^\d{5}(-\d{4})?$/, "Invalid input. must be 5 numbers\n")
    end
    get_zip
  end

  def get_restaurant_size
    size = TTY::Prompt.new
    puts "\e[2J\e[f"
    get_size = size.slider("\nAmount of results you wish to see:".bold, min: 1, max: 20, step: 1, default: 5)
    get_size
  end

  def get_restaurant_state
    state = TTY::Prompt.new
    get_state = state.ask("\nEnter the 2 State digits:", required: true) do |q|
      q.modify :remove
      q.validate(/[a-z]{2}/i, 'Invalid input. must be two letters')
    end
    get_state
  end

  def continue_review
    continue = TTY::Prompt.new
    to_continue = continue.select('What would you like to do next?', 'Look up another Restaurant', 'Restart the program', 'send the info to your email', 'exit')
    case to_continue
    when 'exit'
      exit

    when 'Look up another Restaurant'
      puts "\e[2J\e[f"
      look_up = TTY::Prompt.new
      get_look_up = look_up.multi_select(
        "\nSelect the Restaurant you would like to see more details on:\n\n",
        @manager.outputer,
        min: 1,
        max: 1,
        require: true,
        per_page: 6
      )
      @rest_API.get_review_data(get_look_up)
      @manager.outputer_review(@rest_API.review_data)
      continue_review
    when 'Restart the program'
      puts "\e[2J\e[f"
      welcome
      @manager.all.clear
      @manager.outputer.clear
    when 'send the info to your email'
      new_mail_class = Email.new
      receive_email = TTY::Prompt.new
      send_email_to_user = receive_email.ask('What is your email?') { |q| q.validate :email }
      new_mail_class.user_ia(send_email_to_user)
      new_mail_class.email_sender(@rest_API.review_data)
      puts 'success!, Program is shutting down, if you wish, you can restart it.'.green.bold
      puts @manager.outputer_review(@manager.outputer_review(@rest_API.review_data))
      @manager.all.clear
      @manager.outputer.clear
      welcome
    end
  end

  def run
    puts "\e[2J\e[f"
    sleep(0.2)
    puts "Hello! welcome to Your favorite Restaraunt locator.\n".blue.bold
    sleep(0.7)
    puts "We're getting things ready, just a second please...\n\n".blue.bold
    sleep(1.5)
    @manager = RestaurantManager.new
    welcome
  end
end
