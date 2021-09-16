# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < ProtectedController #:nodoc:
      before_action :set_project, only: %i[show edit update destroy]

      def index
        @projects = current_user.projects.all
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
        @project = current_user.projects.build(project_params)

        if authorized?
          respond_to do |format|
            if @project.save
              format.json { render :show, status: :created, location: api_v1_project_path(@project) }
            else
              format.json { render json: @project.errors, status: :unprocessable_entity }
            end
          end
        else
          handle_unauthorized
        end
      end

      def update
        if authorized?
          respond_to do |format|
            if @project.update(project_params)
              format.json { head :no_content }
            else
              format.json { render json: @project.errors, status: :unprocessable_entity }
            end
          end
        else
          handle_unauthorized
        end
      end

      def destroy
        if authorized?
          @project.destroy
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
        @project = Project.find(params[:id])
      end

      def project_params
        params.require(:project).permit(:title)
      end
    end
  end
end
