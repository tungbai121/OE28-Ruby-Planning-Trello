module DeadlinesHelper
  def deadline_status card
    return unless card.deadline

    if !card.completed && card.deadline < DateTime.now
      "overdue"
    elsif card.completed
      "completed"
    else
      "incompleted"
    end
  end
end
