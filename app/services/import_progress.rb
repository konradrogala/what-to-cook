# frozen_string_literal: true

require 'ruby-progressbar'

class ImportProgress
  def initialize(total)
    @progressbar = ProgressBar.create(
      title: "Importing Recipes",
      total: total,
      format: "%a %B %p%% %t",
      progress_mark: "#",
      remainder_mark: "."
    )
  end

  def update(current, total)
    progressbar.increment if current <= total
  end

  private

  attr_reader :progressbar
end
