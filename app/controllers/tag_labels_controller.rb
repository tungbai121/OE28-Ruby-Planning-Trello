class TagLabelsController < ApplicationController
  before_action :find_board, :find_tag
  before_action :find_relation, only: :destroy

  def create
    label_ids = params[:label]
    label_ids.each do |item|
      new_relation = TagLabel.new label_id: item, tag_id: params[:tag_id]
      flash[:danger] = t".fail" unless new_relation.save
    end
    flash[:success] = t ".success"
    respond_to :js
  end

  def destroy
    if @relation.destroy
      flash[:warning] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    respond_to :js
  end

  private

  def find_board
    @board = Board.find params[:board_id]
  end

  def find_relation
    @relation = TagLabel.find_relation params[:tag_id], params[:label_id]
    return if @relation

    flash[:danger] = t ".cant_delete"
    redirect_to root_path
  end

  def find_tag
    @edited_tag = Tag.find params[:tag_id]
    @tag_labels = @edited_tag.labels
  end
end
