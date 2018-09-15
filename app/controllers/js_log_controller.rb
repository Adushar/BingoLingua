class JsLogController < ApplicationController
  def create
    @js_log = JsLog.new(errors_arr: params[:log])
    if @js_log.save
      head :ok
    end
  end
end
