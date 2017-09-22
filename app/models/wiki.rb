class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborations
  has_many :users, through: :collaborations
  
  delegate :users, to: :collaborations
  
  
  # even necessary?
  def collaborations
    Collaboration.where(wiki_id: id)
  end
  
  def public?
    !private
  end
  
  def owner
    user
  end
  
  def collaborators 
    users
  end
  
  
  default_scope { order('created_at DESC') }
end
