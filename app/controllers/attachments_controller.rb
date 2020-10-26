class AttachmentsController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: :create
  def create
    @attachment = @tag.attachments.build attachment_params
    if @attachment.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def attachment_params
    params.require(:attachment).permit Attachment::ATTACHMENT_PARAMS
  end

  def load_data
    @board = Board.find params[:board_id]
    @tag = Tag.find params[:tag_id]
  end
end
