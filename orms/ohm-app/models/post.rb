class Post < Ohm::Model
  # Examples:
  # attribute :name
  # attribute :email
  # reference :venue, Venue
  # set :participants, Person
  # counter :votes
  #
  # index :name
  #
  # def validate
  #   assert_present :name
  # end

  attribute :name
  attribute :text
end
