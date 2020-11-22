class AttachmentsController < ApplicationController
  before_action :load_data, :check_permission, only: %i(create update destroy)
  before_action :find_attachment, only: %i(update destroy)

  def create
    @attachment = @card.attachments.build attachment_params
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
    @card = Card.find params[:card_id]
  end

  def find_attachment
    @attachment = Attachment.find params[:id]
  end
end
