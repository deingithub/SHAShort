module SHAShortFormResultView
	extend self
	def render(handler_output)
		handler_output = JSON.parse(handler_output).as_h
		return case handler_output["status"]
		when "success"
			<<-STR
			<div id="target" class="success"><p>✔ Successfully shortened</p><a href="/resolve/#{handler_output["hash"]}">https://ding.15318.de/resolve/#{handler_output["hash"].to_s[0,32]}…</a></div>
			STR
		when "rate-limited"
			<<-STR
			<div id="target" class="success"><p>✘ Error</p>You are being rate-limited.</div>
			STR
		else
			<<-STR
			<div id="target" class="error"><p>✘ Error</p>Internal Server Error</div>
			STR
		end
	end
end
