class ListsController < ApplicationController
  before_filter :set_list, :only => [:update, :destroy]

  def create
    @list = List.new(params[:list])

    if @list.save
      render :json => @list, :status => 201
    else
      render :status => 400
    end
  end

  def update
    @list.update_attributes(params[:list])
    render :json => @list, :status => 200
  end

  def reorder
    lists = List.find(params[:list])
    params[:list].each_with_index do |list_id, index|
      lists.detect { |list| list.id == list_id.to_i }.update_attribute(:position, index)
    end
    render :text => 'ok', :status => 200
  end

  def destroy
    @list.destroy
    render :text => 'ok', :status => 200
  end

  protected

    def set_list
      @list = List.find(params[:id])
    end
end
