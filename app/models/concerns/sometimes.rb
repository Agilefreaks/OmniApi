module Concerns
  module Sometimes
    extend ActiveSupport::Concern

    included do
      field :via_omnipaste, type: Boolean, default: true
    end
  end
end
