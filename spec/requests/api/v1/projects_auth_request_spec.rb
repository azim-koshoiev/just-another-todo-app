# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  let!(:user) do
    user_with_projects(
      projects_count: 1
    )
  end
  let(:project_id) { user.projects.first.id }

  context 'when user not logged in' do
    describe 'GET /api/v1/projects' do
      before { get api_v1_projects_path }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'GET /api/v1/projects/:id' do
      before { get api_v1_project_path(project_id) }
      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'POST /api/v1/projects' do
      let(:valid_attrs) { { project: { title: 'Title' } } }

      before { post api_v1_projects_path, params: valid_attrs }

      it 'responses with 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'PUT /api/v1/projects/:id' do
      let(:valid_attrs) { { project: { title: 'Title' } } }

      before { put api_v1_project_path(project_id), params: valid_attrs }

      it 'responses with 401' do
        expect(response).to have_http_status(401)
      end
    end

    describe 'DELETE /api/v1/projects/:id' do
      before { delete api_v1_project_path(project_id) }

      it 'responses with 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is trying to access unauthorized resources' do
      let!(:user2) do
        user_with_projects(
          projects_count: 1
        )
      end
      before { sign_in user2 }

      describe 'GET /api/v1/projects' do
        before { get api_v1_projects_path }
        it 'is returns own projects' do
          json = JSON.parse(response.body)
          expect(json.first['id']).to eq(user2.projects.first.id)
        end
      end
      describe 'GET /api/v1/projects/:id' do
        before { get api_v1_project_path(project_id) }
        it 'responds with 401' do
          json = JSON.parse(response.body)
          expect(json).to include 'error'
          expect(response).to have_http_status(401)
        end
      end
      describe 'POST /api/v1/projects' do
        let(:valid_attrs) { { project: { title: 'Title' } } }

        before { post api_v1_projects_path, params: valid_attrs }

        it 'is creates own resource' do
          expect(Project.find_by(user: user2).user_id).to eq(user2.id)
        end
      end
      describe 'PUT /api/v1/projects/:id' do
        let(:valid_attrs) { { project: { title: 'Title' } } }

        before { put api_v1_project_path(project_id), params: valid_attrs }

        it 'responses with 401' do
          expect(response).to have_http_status(401)
        end
      end
      describe 'DELETE /api/v1/projects/:id' do
        before { delete api_v1_project_path(project_id) }

        it 'responses with 401' do
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
