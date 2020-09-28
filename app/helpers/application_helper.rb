module ApplicationHelper
  def toastr_flash type
    case type
    when "danger"
      "toastr.error"
    when "success"
      "toastr.success"
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
