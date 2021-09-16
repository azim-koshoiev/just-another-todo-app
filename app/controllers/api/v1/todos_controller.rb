# frozen_string_literal: true

module Api
  module V1
    class TodosController < ProtectedController #:nodoc:
      before_action :set_project
      before_action :set_todo, only: %i[show edit update destroy]

      def index
        @todos = @project.todos
      end

      def show
        if authorized?
          respond_to do |format|
            format.json { render :show }
          end
        else
          handle_unauthorized
        end
      end

      def create
        @todo = @project.todos.build(todo_params)

        if authorized?
          respond_to do |format|
            if @todo.save
              format.json do
                render :show, status: :created, location: api_v1_project_todos_path(@todo)
              end
            else
              format.json { render json: @todo.errors, status: :unprocessable_entity }
            end
          end
        else
          handle_unauthorized
        end
      end

      def update
        if authorized?
          respond_to do |format|
            if @todo.update(todo_params)
              format.json { head :no_content }
            else
              format.json do
                render json: @todo.errors, status: :unprocessable_entity
              end
            end
          end
        else
          handle_unauthorized
        end
      end

      def destroy
        if authorized?
          @todo.destroy
          respond_to do |format|
            format.json { head :no_content }
          end
        else
          handle_unauthorized
        end
      end

      protected

      def authorized?
        @project.user == current_user
      end

      private

      def set_project
        @project = if params[:project_id].nil?
                     Todo.find(params[:id]).project
                   else
                     current_user.projects.find(params[:project_id])
                   end
      end

      def set_todo
        @todo = @project.todos.find(params[:id])
      end

      def todo_params
        params.require(:todo).permit(
          :id, :title, :complete, :deadline, :project_id
        )
      end
    end
  end
end
