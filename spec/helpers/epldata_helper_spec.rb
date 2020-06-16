# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpldataHelper, type: :helper do
  describe '#fetch_current_matchday' do
    it 'returns an integer' do
      expect(helper.fetch_current_matchday).to be_a_kind_of(Integer)
    end
  end
end
