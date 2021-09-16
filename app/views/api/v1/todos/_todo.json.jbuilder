# frozen_string_literal: true

json.extract! todo,
              :id,
              :title,
              :complete,
              :deadline,
              :created_at,
              :updated_at,
              :position,
              :project_id
