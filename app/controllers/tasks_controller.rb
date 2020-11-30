class TasksController < ApplicationController
  before_action :set_tasks, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in,only: [:index, :show, :new, :edit]
  
  
  def index
    @task = current_user.tasks.build
    @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(10)
  end
  
  def show
    set_tasks
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Taskが正常に新規投稿されました'
      redirect_to root_url
    else
      flash.now[:danger] = 'Taskが投稿されませんでした'
      render :new
    end
  end
  
  def edit
    set_tasks
  end
  
  def update
    set_tasks
    
    if @task.update(task_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] ='Taskは更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    set_tasks
    @task.destroy
    
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_tasks
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content,:status)
  end
  
end
