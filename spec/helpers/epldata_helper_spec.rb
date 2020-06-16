# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpldataHelper, type: :helper do
  describe '#fetch_current_matchday' do
    it 'returns an integer' do
      expect(helper.fetch_current_matchday).to be_a_kind_of(Integer)
    end
  end
  describe '#update_matchday_if_later' do
    test_matchday = CurrentMatchday.create(matchday: 15)

    it 'skips update when database has later current matchday' do
      expect { helper.update_matchday_if_later(test_matchday, 12) }.to_not(
        change { test_matchday.matchday }
      )
    end

    it 'updates matchday when database has earlier matchday' do
      expect { helper.update_matchday_if_later(test_matchday, 28) }.to(
        change { test_matchday.matchday }.to(28)
      )
    end
  end
end
