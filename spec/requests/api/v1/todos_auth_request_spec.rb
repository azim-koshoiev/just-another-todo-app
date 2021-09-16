# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Todos', type: :request do
  let!(:user) do
    create(:user) do |u|
      create(:project, user: u) do |project|
        create_list(:todo, 1, project: project)
      end
    end
  end
  let(:project_id) { user.projects.first.id }
  let(:todos) { user.projects.first.todos }
  let(:todo_id) { todos.first.id }

  context 'when user not logged in' do
    describe 'GET /api/v1/projects/:project_id/todos' do
      before { get api_v1_project_todos_path(project_id) }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end
    describe 'GET /api/v1/projects/:project_id/todos/:id' do
      before { get api_v1_project_todo_path(project_id, todo_id) }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end
    describe 'POST /api/v1/projects/:project_id/todos' do
      let(:valid_attrs) { { todo: { title: 'Title', project_id: project_id } } }

      before { post api_v1_project_todos_path(project_id), params: valid_attrs }

      it 'responses with 401' do
        expect(response).to have_http_status(401)
      end
    end
    describe 'PUT /api/v1/projects/:project_id/todos/:id' do
      let(:valid_attrs) { { todo: { title: 'New Title' } } }

      before { put api_v1_project_todo_path(project_id, todo_id), params: valid_attrs }

      it 'responses with 401' do
        expect(response).to have_http_status(401)
      end
    end
    describe 'DELETE /api/v1/projects/project_id/todos/:id' do
      before { delete api_v1_project_todo_path(project_id, todo_id) }
      it 'responses with 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is trying to access unauthorized resources' do
      let!(:user2) do
        create(:user) do |u|
          create(:project, user: u) do |project|
            create_list(:todo, 1, project: project)
          end
        end
      end
      before { sign_in user2 }

      describe 'GET /api/v1/projects/:project_id/todos' do
        before { get api_v1_project_todos_path(user.projects.first.id) }
        it 'is returns with 404' do
          expect(response).to have_http_status(404)
        end
      end
      describe 'GET /api/v1/projects/:project_id/todos/:id' do
        before { get api_v1_project_todo_path(user.projects.first.id, todo_id) }
        it 'responds with 404' do
          expect(response).to have_http_status(404)
        end
      end
      describe 'POST /api/v1/projects/:project_id/todos' do
        let(:valid_attrs) { { todo: { title: 'Title', project_id: project_id } } }

        before { post api_v1_project_todos_path(project_id), params: valid_attrs }

        it 'is creates own resource' do
          expect(Project.find_by(user: user2).user_id).to eq(user2.id)
        end
      end

      describe 'PUT /api/v1/projects/:project_id/todos/:id' do
        let(:valid_attrs) { { todo: { title: 'New Title' } } }

        before { put api_v1_project_todo_path(project_id, todo_id), params: valid_attrs }

        it 'responses with 404' do
          expect(response).to have_http_status(404)
        end
      end

      describe 'DELETE /api/v1/projects/project_id/todos/:id' do
        before { delete api_v1_project_todo_path(project_id, todo_id) }

        it 'responses with 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
