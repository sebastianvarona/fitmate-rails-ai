module ApplicationHelper
  def active_link(link_path)
      current_page?(link_path) ? "block rounded-lg bg-base-300 px-4 py-2 text-sm font-medium" : "block rounded-lg px-4 py-2 text-sm font-medium text-gray-500 hover:bg-base-300 hover:text-gray-700"
  end
end
