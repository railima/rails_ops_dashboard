# frozen_string_literal: true

module DatabaseUpdate
  class AddTestData
    def call
      Rails.logger.info('[Seed] AddTestData executed')
    end
  end
end
