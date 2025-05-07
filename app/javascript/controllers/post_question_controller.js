import { Controller } from "@hotwired/stimulus"
import { post } from '@rails/request.js'
import showdown from "showdown"

// Connects to data-controller="post-question"
export default class extends Controller {
  static targets = ["input", "chat"]

  connect() {
    console.log("Connected to PostQuestion Controller")
    const scrollContainer = document.querySelector("#scroll_content")
    scrollContainer.scrollTop = scrollContainer.scrollHeight;
  }

  async submit(e) {
    const scrollContainer = document.querySelector("#scroll_content")

    const prompt = e.target.value.trim()
    if (!prompt) return

    const url = this.inputTarget.dataset.url

    this.inputTarget.value = ""
    this.chatTarget.innerHTML += `
      <li class="chat chat-end">
        <div class="chat-bubble chat-bubble-success whitespace-pre-wrap">${prompt}</div>
      </li>
    `
    scrollContainer.scrollTop = scrollContainer.scrollHeight;

    const response = await post(url, { body: JSON.stringify({ prompt }) })
    if (response.ok) {
      const { answer } = await response.json

      const converter = new showdown.Converter()
      const html = converter.makeHtml(answer)

      this.chatTarget.innerHTML += `
        <li class="chat chat-start">
          <div class="chat-bubble prose">${html}</div>
        </li>
      `
      this.inputTarget.disabled = false
      scrollContainer.scrollTop = scrollContainer.scrollHeight;
    }
  }
}
