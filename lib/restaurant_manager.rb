class RestaurantManager
  attr_accessor :all

  def initialize
    @all = []
  end

  def receiver(api_info)
    api_info['result']['data'].each do |index|
      @all << Restaurant.new(index['address']['formatted'], index['restaurant_name'])
    end
  end

  def outputer
    options = []
    if !@all.empty?
      @all.select { |i| options << "#{i.name} is located at #{i.address}\n" }
      options
    else
      puts 'we encountered a problem. please try again.'
      Menu.new.run
    end
  end

  def outputer_review(review_data)
    puts "\e[2J\e[f"
    if !review_data.nil?
      case review_data[:order]
      when nil
        puts(
          "\nTitle: #{review_data[:title]} is located at #{review_data[:address]}",
          "\nType: #{review_data[:type]}.",
          "\nRating: #{review_data[:rating]}.".bold.green,
          "\nReview Count:#{review_data[:review_count]}.".bold.green
        )
      else
        puts(
          "\nTitle: #{review_data[:title]} is located at #{review_data[:address]}",
          "\nType: #{review_data[:type]}.",
          "\nRating: #{review_data[:rating]}.".bold.red,
          "\nReview Count:#{review_data[:review_count]}.".bold.red,
          "\nIf you feel like it, you can find #{review_data[:title]} in any of these platforms:\n",
          "#{review_data[:order]}\n".bold.blue
        )
      end
    else
      puts "Sorry, couldn't fetch any results. perhaps we try again?\n\n"
    end
    sleep(1)
  end
end
