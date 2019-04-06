function responseToHTML(content) {
	content = JSON.parse(content);
	switch (content.status) {
		case 'error':
			return `<div id="target" class="error"><p>Error</p>Service returned status ${content.status}</div>`;
		case 'rate-limited':
			return `<div id="target" class="error"><p>Error</p>You are being rate limited.</div>`;
		case 'success':
			return `<div id="target" class="success"><p>✔ Successfully shortened</p><a href="/resolve/${content.hash}">https://ding.15318.de/resolve/${content.hash.substring(0,32)}…</a></div>`;
	}
}
