module ApplicationHelper
  def task_label(status)
    if status == "Overdue"
      "<span class='label round alert'>#{status}</span>"
    elsif status == "Completed"
      "<span class='label round success'>#{status}</span>"
    else
      "<span class='label round secondary'>#{status}</span>"
    end
  end
  
  def priority_label(priority)
    if priority == 1
      "<span class='label round alert'>High</span>"
    elsif priority == 2
      "<span class='label round'>Med</span>"
    else
      "<span class='label round secondary'>Low</span>"
    end
  end

end
