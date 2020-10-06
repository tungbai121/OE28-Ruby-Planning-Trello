module ChecklistsHelper
  def progress checklists
    return if checklists.blank?

    (checklists.checked.size * 100 / checklists.size).to_s + "%"
  end
end
