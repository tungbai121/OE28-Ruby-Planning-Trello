module DeadlinesHelper
  def deadline_status tag
    return unless tag.deadline

    if !tag.completed && tag.deadline < DateTime.now
      "overdue"
    elsif tag.completed
      "completed"
    else
      "incompleted"
    end
  end
end
