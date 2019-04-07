require "../../../logic"

module SHAShortFormResultView
	extend self
	def render(handler_output)
			<<-STR
			<div id="target" class="success"><p>✔ Successfully shortened</p><a href="/resolve/#{handler_output}">https://ding.15318.de/resolve/#{handler_output[0,32]}…</a></div>
			STR
	end
	def render_error
			<<-STR
			<div id="target" class="error"><p>✘ Error</p>Something went wrong.</div>
			STR
	end
end

post "/api/web/create" do |env|
	begin
		hash = SHAShortLogic.create_link(env.params.body["url"])
		next SHAShortFormResultView.render(hash)
	rescue e
		puts e
		next SHAShortFormResultView.render_error
	end
end
