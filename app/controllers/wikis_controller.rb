class WikisController < ApplicationController
  before_action :authorize_user, only: [:show, :edit]
  before_action :verify_private, only: [:update]
  
  
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.private = params[:wiki][:private]
    @wiki.user = current_user
    
    if @wiki.save 
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else 
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    @prospective_collaborators = User.all.select { |user| !@wiki.collaborators.include?(user) }
    @current_collaborators = User.all.select { |user| @wiki.collaborators.include?(user) && @wiki.user != user } 
  end
  
  
  def update
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.private = params[:wiki][:private]
    
    add_collaborators
    remove_collaborators
    
    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else 
      alert[:notice] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end
  
  def destroy 
    @wiki = Wiki.find(params[:id])
    
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else 
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end
  
  
  private
  
  # authorize_user
  # => determine if a private wiki can be accessed by current user
  def authorize_user 
    wiki = Wiki.find(params[:id])
    unless wiki.public? || current_user.admin? || current_user == wiki.user || wiki.collaborators.include?(current_user)
      flash[:alert] = "That wiki is private."
      redirect_to wikis_path
    end
  end
  
  # verify_private
  # => confirms user has permission to create a private wiki
  def verify_private
    if (params[:wiki][:private] && current_user.standard?)
      flash[:alert] = "Standard users can't make private wikis."
      redirect_to edit_wiki_path params[:id]
    end
  end
  
  # add_collaborators
  # => create new Collaboration objects for added collaborators
  def add_collaborators
    return unless params[:add_collaborator]
    collaborator_user_ids = params[:add_collaborator][:collaborator_id].reject { |e| e.empty? }
    for user_id in collaborator_user_ids do 
      add_collaboration(user_id)
    end
  end
  
  # add_collaboration(...)
  # => creates a new Collaboration object
  def add_collaboration(user_id)
    Collaboration.create!({user_id: user_id, wiki_id: params[:id]})
  end
  
  # remove_collaborators
  # => delete Collaboration objects for existing collaborators
  def remove_collaborators
    return unless params[:remove_collaborator]
    collaborator_user_ids = params[:remove_collaborator][:collaborator_id].reject { |e| e.empty? }
    for user_id in collaborator_user_ids do 
      remove_collaboration(user_id)
    end
  end
  
  # remove_collaboration(...)
  # => destroys a Collaboration object
  def remove_collaboration(user_id)
    Collaboration.where(["user_id = ? and wiki_id = ?", user_id, params[:id]]).destroy_all
  end
end
