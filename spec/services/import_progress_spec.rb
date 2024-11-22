# frozen_string_literal: true

require 'rails_helper'
require 'ruby-progressbar'

RSpec.describe ImportProgress do
  let(:total) { 5 }
  let(:progress) { described_class.new(total) }
  let(:progressbar) { instance_double(ProgressBar::Base) }

  before do
    allow(ProgressBar).to receive(:create).and_return(progressbar)
    allow(progressbar).to receive(:increment)
  end

  describe '#update' do
    it 'increments progress when current is less than or equal to total' do
      progress.update(3, total)
      expect(progressbar).to have_received(:increment)
    end

    it 'does not increment progress when current is greater than total' do
      progress.update(6, total)
      expect(progressbar).not_to have_received(:increment)
    end
  end
end
