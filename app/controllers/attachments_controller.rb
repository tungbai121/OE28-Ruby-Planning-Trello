class AttachmentsController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: %i(create update destroy)
  before_action :load_attachment, only: %i(update destroy)

  def create
    @attachment = @tag.attachments.build attachment_params
    if @attachment.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def update
    if @attachment.update attachment_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def destroy
    if @attachment.destroy
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
