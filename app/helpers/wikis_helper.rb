module WikisHelper
  def render_to_markdown(text)
    # initialize Markdown renderer
    @renderer ||= Redcarpet::Render::HTML.new
    @markdown ||= Redcarpet::Markdown.new(@renderer)
    
    @markdown.render(text).html_safe
  end
  
  def user_has_collaboration_permissions?(wiki)
    wiki.private && (wiki.user == current_user || current_user.premium? || current_user.admin?)
  end
end
