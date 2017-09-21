module WikisHelper
  def to_markdown(text)
    # initialize Markdown renderer
    @renderer ||= Redcarpet::Render::HTML.new
    @markdown ||= Redcarpet::Markdown.new(@renderer)
    
    @markdown.render(text).html_safe
  end
end
