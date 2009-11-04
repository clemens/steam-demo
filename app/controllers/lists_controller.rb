class ListsController < ApplicationController
  def create
    @list = List.new(params[:list])

    if @list.save
      render :json => @list, :status => 201
    else
      render :status => 400
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy
    render :text => 'ok', :status => 200
  end
end
