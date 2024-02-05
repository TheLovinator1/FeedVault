package main

import (
	"log"
	"net/http"
	"strings"
)

func IndexHandler(w http.ResponseWriter, _ *http.Request) {

	content := `<h2>Feeds to archive</h2>
    <p>
        Input the URLs of the feeds you wish to archive below. You can add as many as needed, and access them through the website or API. Alternatively, include links to .opml files, and the feeds within will be archived.
    </p>
    <form action="/add" method="post">
        <textarea id="urls" name="urls" rows="5" cols="50" required></textarea>
        <button type="submit">Add feeds</button>
    </form>
    <br>
    <p>You can also upload .opml files containing the feeds you wish to archive:</p>
    <form enctype="multipart/form-data" method="post" action="/upload_opml">
        <input type="file" name="file" id="file" accept=".opml" required>
        <button type="submit">Upload OPML</button>
    </form>
	`

	FAQ := `

    <h2>FAQ</h2>
    <details>
        <summary>What are web feeds?</summary>
        <p>
            Web feeds are a way to distribute content on the web. They allow users to access updates from websites without having to visit them directly. Feeds are typically used for news websites, blogs, and other sites that frequently update content.
            <br>
            You can read more about web feeds on <a href="https://en.wikipedia.org/wiki/Web_feed">Wikipedia</a>.
        </p>
        <hr>
    </details>
    <details>
        <summary>What is FeedVault?</summary>
        <p>
            FeedVault is a service that archives web feeds. It allows users to access and search for historical content from various websites. The service is designed to preserve the history of the web and provide a reliable source for accessing content that may no longer be available on the original websites.
        </p>
        <hr>
    </details>
    <details>
        <summary>Why archive feeds?</summary>
        <p>
            Web feeds are a valuable source of information, and archiving them ensures that the content is preserved for future reference. By archiving feeds, we can ensure that historical content is available for research, analysis, and other purposes. Additionally, archiving feeds can help prevent the loss of valuable information due to website changes, outages, or other issues.
        </p>
        <hr>
    </details>
    <details>
        <summary>How does it work?</summary>
        <p>
            FeedVault is written in Go and uses the <a href="https://github.com/mmcdole/gofeed">gofeed</a> library to parse feeds. The service periodically checks for new content in the feeds and stores it in a database. Users can access the archived feeds through the website or API.
        <hr>
    </details>
    <details>
        <summary>How can I access the archived feeds?</summary>
        <p>
            You can access the archived feeds through the website or API. The website provides a user interface for searching and browsing the feeds, while the API allows you to access the feeds programmatically. You can also download the feeds in various formats, such as JSON, XML, or RSS.
        </p>
    </details>
	`

	content += FAQ

	htmlData := HTMLData{
		Title:        "FeedVault",
		Description:  "FeedVault - A feed archive",
		Keywords:     "RSS, Atom, Feed, Archive",
		Author:       "TheLovinator",
		CanonicalURL: "http://localhost:8000/",
		Content:      content,
	}
	html := fullHTML(htmlData, nil)
	w.Write([]byte(html))
}

func ApiHandler(w http.ResponseWriter, _ *http.Request) {
	htmlData := HTMLData{
		Title:        "FeedVault API",
		Description:  "FeedVault API - A feed archive",
		Keywords:     "RSS, Atom, Feed, Archive, API",
		Author:       "TheLovinator",
		CanonicalURL: "http://localhost:8000/api",
		Content:      "<p>Here be dragons.</p>",
	}
	html := fullHTML(htmlData, nil)
	w.Write([]byte(html))
}
func FeedsHandler(w http.ResponseWriter, _ *http.Request) {
	htmlData := HTMLData{
		Title:        "FeedVault Feeds",
		Description:  "FeedVault Feeds - A feed archive",
		Keywords:     "RSS, Atom, Feed, Archive",
		Author:       "TheLovinator",
		CanonicalURL: "http://localhost:8000/feeds",
		Content:      "<p>Here be feeds.</p>",
	}
	html := fullHTML(htmlData, nil)
	w.Write([]byte(html))
}

func AddFeedHandler(w http.ResponseWriter, r *http.Request) {
	var parseErrors []ParseResult

	// Parse the form and get the URLs
	r.ParseForm()
	urls := r.Form.Get("urls")
	if urls == "" {
		http.Error(w, "No URLs provided", http.StatusBadRequest)
		return
	}

	for _, feed_url := range strings.Split(urls, "\n") {
		// TODO: Try to upgrade to https if http is provided

		// Validate the URL
		err := validateURL(feed_url)
		if err != nil {
			parseErrors = append(parseErrors, ParseResult{FeedURL: feed_url, Msg: err.Error(), IsError: true})
			continue
		}

		// "Add" the feed to the database
		log.Println("Adding feed:", feed_url)
	}

	htmlData := HTMLData{
		Title:        "FeedVault - Add Feeds",
		Description:  "FeedVault - Add Feeds",
		Keywords:     "RSS, Atom, Feed, Archive",
		Author:       "TheLovinator",
		CanonicalURL: "http://localhost:8000/add",
		Content:      "<p>Feeds added.</p>",
	}

	html := fullHTML(htmlData, parseErrors)
	w.Write([]byte(html))
}
