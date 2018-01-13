class User
  include Mongoid::Document
  
  field :name, type: String
  field :age, type: BigDecimal
  field :password, type: String
  
  validates :name, presence: true, uniqueness: true
  validates :age, numericality: true
end
