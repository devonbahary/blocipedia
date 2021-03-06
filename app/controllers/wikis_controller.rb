class WikisController < ApplicationController
  before_action :authorize_user, only: [:show, :edit]
  
  
  def index
    @wikis = Wiki.all
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
  end
  
  def update
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.private = params[:wiki][:private]
    
    if !(params[:wiki][:private] && current_user.standard?) && @wiki.save
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
  
  def authorize_user 
    wiki = Wiki.find(params[:id])
    unless !wiki.private || current_user.admin? || current_user == wiki.user
      flash[:alert] = "That wiki is private."
      redirect_to wikis_path
    end
  end
end
