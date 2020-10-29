class CheckedChecklistsController < ChecklistsController
  before_action :load_data, :load_checklist,
                :check_permission, only: :update

  def update
    if @checklist.update checked: params[:checklist][:checked]
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end
end
