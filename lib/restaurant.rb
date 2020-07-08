class Restaurant
  attr_accessor :address, :name

  @@all = []

  def initialize(address, name)
    @address = address
    @name = name
    @@all << self
  end

  def self.all
    @@all
  end
end
