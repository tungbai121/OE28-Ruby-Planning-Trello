class CardLabelsController < ApplicationController
  before_action :find_board, :find_card, :check_permission
  before_action :find_relation, only: :destroy

  def create
    label_ids = params[:label]
    new_relations = []
    label_ids.each do |item|
      new_relations << CardLabel.new(label_id: item, card_id: params[:card_id])
    end
    if CardLabel.import new_relations
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  def edit
    respond_to :js
  end

  def destroy
    if @relation.destroy
      flash.now[:warning] = t ".success"
    else
      flash.now[:danger] = t ".fail"
    end
    respond_to :js
  end

  private

  def find_board
    @board = Board.find params[:board_id]
  end

  def find_relation
    @relation = CardLabel.find_relation params[:card_id], params[:label_id]
    return if @relation

    flash[:danger] = t ".cant_delete"
    redirect_to root_path
  end

  def find_card
    @edited_card = Card.find params[:card_id]
    @card_labels = @edited_card.labels
  end
end
