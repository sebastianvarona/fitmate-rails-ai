import { Controller } from "@hotwired/stimulus"
import { post } from '@rails/request.js'

// Connects to data-controller="weekday-select"
export default class extends Controller {
  static values = {
    day: String,
    url: String
  }

  connect() {
  }

  async submit() {
    const checked = +this.element.checked

    const response = await post(this.urlValue, { body: JSON.stringify({ day: this.dayValue, checked }) })
    if (response.ok) {
      Turbo.visit(response.response.url)
    }
  }
}
