class TasksController < ApplicationController
  before_filter :set_lists, :only => :index

  def create
    @task = Task.new(params[:task])

    if @task.save
      render :json => @task, :status => 201
    else
      render :status => 400
    end
  end

  def reorder
    tasks = Task.find(params[:lists].values.flatten)
    params[:lists].each do |list_id, task_ids|
      task_ids.each_with_index do |task_id, index|
        tasks.detect { |task| task.id == task_id.to_i }.update_attributes(:list_id => list_id, :position => index)
      end
    end # yuck
    render :text => 'ok', :status => 200
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    render :text => 'ok', :status => 200
  end

  protected
    def set_lists
      @lists = List.all
    end
end
