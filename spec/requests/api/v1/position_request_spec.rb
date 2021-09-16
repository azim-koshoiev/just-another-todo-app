# frozen_string_litera: true

require 'rails_helper'

# TODO: Remove duplicated code (dry)

RSpec.describe "Api::V1::Positions", type: :request do
  context 'when user logged in' do
    let!(:user) do
      create(:user) do |user|
        create(:project, user: user) do |project|
          create_list(:todo, 3, project: project)
        end
      end
    end
    let(:todo1) { user.projects.first.todos.first }
    let(:todo2) { user.projects.first.todos.second }
    let(:todo3) { user.projects.first.todos.third }

    before do
      expect(todo1.first?).to be true
      expect(todo2.first?).to be false
      expect(todo3.last?).to be true
    end
    before { sign_in user }

    describe 'GET /api/v1/todos/:id/position/:direction' do
      context 'when moving top item to the top' do
        before { patch up_api_v1_todo_position_path(todo1.id) }

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns projects' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
        end
        it 'should stay on the top' do
          expect(Todo.find(todo1.id).first?).to be true
        end
      end

      context 'when moving second item to the top' do
        before { patch up_api_v1_todo_position_path(todo2.id) }

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns position' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
        end
        it 'should become top item' do
          expect(Todo.find(todo2.id).first?).to be true
          expect(Todo.find(todo1.id).first?).to be false
        end
      end

      context 'when moving last item to the bottom' do
        before { patch down_api_v1_todo_position_path(todo3.id) }

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns position' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['position']).to be_kind_of(Integer)
        end
        it 'is stay as last item' do
          expect(Todo.find(todo3.id).last?).to be true
        end
      end

      context 'when moving last item upper' do
        before { patch up_api_v1_todo_position_path(todo3.id) }

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns position' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['position']).to be_kind_of(Integer)
        end
        it 'should go upper' do
          expect(Todo.find(todo3.id).last?).to be false
          expect(Todo.find(todo2.id).last?).to be true
        end
      end
    end
  end
end
