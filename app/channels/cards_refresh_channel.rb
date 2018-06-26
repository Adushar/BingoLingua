class CardsRefreshChannel < ApplicationCable::Channel
  def subscribed
    stream_from "cards_refresh_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    data = data["data"]
    # cards, selected, numer_of_cards
    cards = Card.where(test: data["test_id"])[0...25]
    level = data["level_dafault"]
    if level == 4
      selected_cards = current_user.cards.where(test: data["test_id"])
    end
    level += 2
    ActionCable.server.broadcast "cards_refresh_channel", messages: {cards: cards, number_of_cards: level, selected_cards: selected_cards }
  end
end
