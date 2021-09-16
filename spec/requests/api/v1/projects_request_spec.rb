# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Projects', type: :request do
  context 'when user logged in' do
    let!(:user) do
      user_with_projects(
        projects_count: 3
      )
    end
    let(:project_id) { user.projects.first.id }

    before { sign_in user }

    describe 'GET /api/v1/projects' do
      before { get api_v1_projects_path }
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns projects' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json.size).to eq(user.projects.size)
      end
    end

    describe 'GET /api/v1/projects/:id' do
      before { get api_v1_project_path(project_id) }
      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end
      it 'returns project' do
        json = JSON.parse(response.body)
        expect(json['id']).to eq(project_id)
      end
    end

    describe 'POST /api/v1/projects' do
      let(:valid_attrs) { { project: { title: 'Title' } } }

      context 'when the request is valid' do
        before { post api_v1_projects_path, params: valid_attrs }

        it 'creates a project' do
          json = JSON.parse(response.body)
          expect(json['title']).to eq(valid_attrs[:project][:title])
        end
        it 'responses with 201' do
          expect(response).to have_http_status(201)
        end
      end
    end

    describe 'PUT /api/v1/projects/:id' do
      let(:valid_attrs) { { project: { title: 'Title' } } }

      context 'when the record exists' do
        before { put api_v1_project_path(project_id), params: valid_attrs }

        it 'responses with 204' do
          expect(response).to have_http_status(204)
        end
        it 'updates the record' do
          expect(response.body).to be_empty
        end
      end

      context 'when the record does not exist' do
        before { put api_v1_project_path(0), params: valid_attrs }

        it 'responses with 404' do
          expect(response).to have_http_status(404)
        end
      end
    end

    describe 'DELETE /api/v1/projects/:id' do
      context 'when the record exists' do
        before { delete api_v1_project_path(project_id) }

        it 'responses with 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'when the record does not exist' do
        before { delete api_v1_project_path(0) }

        it 'responses with 404' do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
