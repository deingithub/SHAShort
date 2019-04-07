require "../../../logic"

module WebAPIResolveEndpoint
  extend self

  def render(handler_output)
    <<-STR
			<div id="target" class="success"><p>✔ Found</p>This link resolves to <code>#{handler_output}</code>.</div>
			STR
  end

	def render_not_found
		<<-STR
			<div id="target" class="error"><p>✘ Not found</p>We don't have this hash stored.</div>
			STR
	end

  def render_error
    <<-STR
			<div id="target" class="error"><p>✘ Error</p>Something went wrong.</div>
			STR
  end
end

get "/api/web/resolve" do |env|
  begin
    hash = URI.unescape(env.params.query["hash"])
    hash = hash.lchop("https://ding.15318.de/resolve/").strip
    url = SHAShortLogic.fetch_link(hash)
    next WebAPIResolveEndpoint.render(url)
  rescue e
    puts e
		if e.is_a? DB::Error
			next WebAPIResolveEndpoint.render_not_found
		end
    next WebAPIResolveEndpoint.render_error
  end
end
