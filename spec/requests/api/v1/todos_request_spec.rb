# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Todos', type: :request do
  context 'when user logged in' do
    let!(:user) do
      create(:user) do |u|
        create(:project, user: u) do |project|
          create_list(:todo, 3, project: project)
        end
      end
    end
    let(:project_id) { user.projects.first.id }
    let(:todos) { user.projects.first.todos }
    let(:todo_id) { todos.first.id }

    before { sign_in user }

    describe 'GET /api/v1/projects/:project_id/todos' do
      before { get api_v1_project_todos_path(project_id) }

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns todos' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json.size).to eq(todos.size)
      end
    end

    describe 'GET /api/v1/projects/:project_id/todos/:id' do
      before { get api_v1_project_todo_path(project_id, todo_id) }
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns todo' do
        json = JSON.parse(response.body)
        expect(json['id']).to eq(todo_id)
      end
    end

    describe 'POST /api/v1/projects/:project_id/todos' do
      let(:valid_attrs) { { todo: { title: 'Title', project_id: project_id } } }

      context 'when the request is valid' do
        before { post api_v1_project_todos_path(project_id), params: valid_attrs }

        it 'creates a todo' do
          json = JSON.parse(response.body)
          expect(json['title']).to eq(valid_attrs[:todo][:title])
        end
        it 'responses with 201' do
          expect(response).to have_http_status(201)
        end
      end
    end

    describe 'PUT /api/v1/projects/:project_id/todos/:id' do
      let(:valid_attrs) { { todo: { title: 'New Title' } } }

      context 'when the record exists' do
        before { put api_v1_project_todo_path(project_id, todo_id), params: valid_attrs }

        it 'responses with 204' do
          expect(response).to have_http_status(204)
        end
        it 'updates the record' do
          expect(response.body).to be_empty
        end
      end

      context 'when the record does not exist' do
        before { put api_v1_project_todo_path(project_id, 0), params: valid_attrs }

        it 'responses with 404' do
          expect(response).to have_http_status(404)
        end
      end
    end

    describe 'DELETE /api/v1/projects/project_id/todos/:id' do
      context 'when the record exists' do
        before { delete api_v1_project_todo_path(project_id, todo_id) }

        it 'responses with 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when the record does not exist' do
        before { delete api_v1_project_todo_path(project_id, 0) }

        it 'responses with 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
