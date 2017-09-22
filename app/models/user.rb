class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :collaborations
  has_many :wikis, through: :collaborations
  
  delegate :wikis, to: :collaborations
  
  after_initialize :init
  
  def init 
    self.role ||= :standard
  end
  
  # even necessary?
  def collaborations
    Collaboration.where(user_id: id)
  end

  
  enum role: [:standard, :admin, :premium]
end
