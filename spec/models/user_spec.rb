# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#hue' do
    it 'gives each person the same hue every time' do
      user = described_class.create!(name: 'Nana Ruth', email: 'ruth@example.com')

      expect(user.hue).to be_between(0, 359)
      expect(described_class.find(user.id).hue).to eq(user.hue)
    end
  end
end
