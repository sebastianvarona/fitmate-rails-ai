import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="chats"
export default class extends Controller {
  submit (e) {
    const search = this.element.querySelector("input[type='search']")
    const title = search.value

    // Check if chat is empty
    if (!title.trim()) {
      e.preventDefault()
      search.parentElement.classList.add('input-error')
      return
    }

    const chatList = document.querySelector('#chats-list')

    // Update title
    document.querySelector('h1').innerText = title

    // Remove chats list
    chatList.innerHTML = ''

    // Add 'chat' entry to dom
    const chatHtml = `
      <li class="chat chat-end">
        <div class="chat-bubble chat-bubble-success whitespace-pre-wrap">${title}</div> 
      </li>
    `
    chatList.insertAdjacentHTML('beforebegin', chatHtml)
  }
}
