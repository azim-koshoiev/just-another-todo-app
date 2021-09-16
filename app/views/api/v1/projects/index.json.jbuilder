# frozen_string_literal: true

json.array! @projects, partial: 'api/v1/projects/project', as: :project
