module GameHelper
  def cookie_level
    cookies[:level] = { value: 1, :expires => 12.month.from_now } if cookies[:level].to_i < 1

    cookies[:level]
  end

  def card_image_class(card)
    shown_card = ShownCard.find_by(user: current_user, card: card)
    class_name = 'card not_drag'
    class_name += ' blured_card' if shown_card&.often_shown? && !current_user.demo_user?

    class_name
  end
end
