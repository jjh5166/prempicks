# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe SetMatchday, type: :worker do
  it { is_expected.to be_processed_in :default }
end
