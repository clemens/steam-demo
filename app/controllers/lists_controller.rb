class ListsController < ApplicationController
  def create
    @list = List.new(params[:list])

    if @list.save
      render :json => @list, :status => 201
    else
      render :status => 400
    end
  end

  def reorder
    lists = List.find(params[:list])
    params[:list].each_with_index do |list_id, index|
      lists.detect { |list| list.id == list_id.to_i }.update_attribute(:position, index)
    end
    render :text => 'ok', :status => 200
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    render :text => 'ok', :status => 200
  end
end
