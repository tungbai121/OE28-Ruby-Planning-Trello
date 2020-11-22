module ApplicationHelper
  def full_title page_title
    base_title = t ".base_title"
    page_title.blank? ? base_title : [page_title, base_title].join(" | ")
  end

  def toastr_flash type
    case type
    when "danger"
      "toastr.error"
    when "success"
      "toastr.success"
    when "warning"
      "toastr.warning"
    else
      "toastr.info"
    end
  end

  def display_error object, method, name
    return unless object&.errors&.key?(method)

    error = "#{name} #{object.errors.messages[method][0]}"
    content_tag :div, error, class: "error-feedback"
  end
end
