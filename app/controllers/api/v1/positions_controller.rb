# frozen_string_literal: true

module Api
  module V1
    class PositionsController < ProtectedController #:nodoc:
      before_action :set_todo, only: %i[show up down]

      def show
        if authorized?
          respond_to do |format|
            format.json { render :show }
          end
        else
          handle_unauthorized
        end
      end

      def up
        if authorized?
          @todo.move_higher

          respond_to do |format|
            format.json { render :show }
          end
        else
          handle_unauthorized
        end
      end

      def down
        if authorized?
          @todo.move_lower

          respond_to do |format|
            format.json { render :show }
          end
        else
          handle_unauthorized
        end
      end

      def authorized?
        @todo.project.user == current_user
      end

      private

      def set_todo
        @todo = Todo.find(params[:todo_id])
      end
    end
  end
end
