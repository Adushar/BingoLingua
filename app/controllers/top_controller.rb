class TopController < ApplicationController
  def index
    @top = TestResult.where('created_at >= ?', 1.month.ago).order(:last_result).group_by(&:user_id)
    @top
  end
end
