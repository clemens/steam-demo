class TasksController < ApplicationController
  before_filter :set_lists, :only => :index
  before_filter :set_list, :only => :reorder

  def create
    @task = Task.new(params[:task])

    if @task.save
      render :json => @task, :status => 201
    else
      render :status => 400
    end
  end

  def reorder
    @list.tasks.each { |task| task.update_attribute(:position, params[:task].index(task.id.to_s)) } # yuck
    render :text => 'ok', :status => 200
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url
  end

  protected
    def set_lists
      @lists = List.all
    end

    def set_list
      @list = List.find(params[:list_id])
    end
end
