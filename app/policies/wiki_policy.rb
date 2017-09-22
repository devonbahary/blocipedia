class WikiPolicy < ApplicationPolicy
  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def update?
    user.present?
  end
  
  class Scope
    attr_reader :user, :scope
    
    def initialize(user, scope)
      @user = user
      @scope = scope
    end
    
    
    # introducing new methods:
    #   - wiki.collaborators
    #   - wiki.public?
    
    def resolve
      wikis = []
      all_wikis = scope.all
      if user.role == 'admin'
        wikis = all_wikis # show all wikis
      elsif user.role == 'premium'
        all_wikis.each do |wiki| 
          if wiki.public? || wiki.owner == user || wiki.collaborators.include?(user)
            wikis << wiki # show public wikis, private wikis they created, or private wikis they are collaborators on
          end
        end
      else 
        all_wikis.each do |wiki|
          if wiki.public? || wiki.collaborators.include?(user)
            wikis << wiki # show public wikis and private wikis they are collaborators on
          end
        end
      end
      wikis
    end
    
  end
end