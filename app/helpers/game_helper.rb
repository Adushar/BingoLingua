module GameHelper
  def cookie_level
    cookies[:level] = { value: 1, :expires => 12.month.from_now } if cookies[:level].to_i < 1

    cookies[:level]
  end
end
