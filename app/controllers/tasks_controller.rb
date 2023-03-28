class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /users
  def index
    @tasks = Task.all
    render json: @tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    render json: @task
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    @task.save!

    render json: @task
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task.update(task_params)
    render json: @task

  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    render json: @task
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
      # binding.pry
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :completed)
    end
end
