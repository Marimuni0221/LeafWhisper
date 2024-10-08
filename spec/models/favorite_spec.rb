# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Favorite do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:favoritable) }
end
