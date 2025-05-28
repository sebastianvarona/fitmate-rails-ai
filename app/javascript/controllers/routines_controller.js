import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="routines"
export default class extends Controller {
  submit () {
    const titleInput = this.element.querySelector("input[name='routine[title]']")
    const contextInput = this.element.querySelector("textarea[name='routine[context]']")
    const submitBtn = this.element.querySelector("input[type='submit']")

    // Check title and context are present
    if (!titleInput.value.trim() || !contextInput.value.trim()) return

    // Disable title input
    titleInput.readOnly = true
    titleInput.style.opacity = '0.6'

    // Disable context input
    contextInput.readOnly = true
    contextInput.style.opacity = '0.6'

    // Disable submit button and show new status
    submitBtn.disabled = true
    submitBtn.value = 'Creando rutina...'
  }
}
