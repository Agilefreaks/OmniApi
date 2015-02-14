module API
  module Entities
    class BaseEntity < Grape::Entity
      format_with(:to_s) { |field| field.to_s }

      with_options(format_with: :to_s) do
        expose :id
      end
    end
  end
end
