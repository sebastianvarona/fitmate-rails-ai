import { Controller } from "@hotwired/stimulus"
import showdown from "showdown"

// Connects to data-controller="markdown-converter"
export default class extends Controller {
  static values = {
    content: String
  }

  connect() {
    const converter = new showdown.Converter()
    const html = converter.makeHtml(this.contentValue)
    this.element.classList.remove("whitespace-pre-wrap")
    this.element.innerHTML = html
  }
}
