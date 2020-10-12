module ChecklistsHelper
  def progress checklists
    return if checklists.blank?

    (checklists.checked.size * 100 / checklists.size).to_s + "%"
  end

  def checklist_status checklists
    return if checklists.blank?

    if checklists.checked.size == checklists.size
      "completed"
    else
      "incompleted"
    end
  end
end
