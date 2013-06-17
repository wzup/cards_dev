# coding: utf-8

{
  :users => {
    # На сколько ставить кук юзеру. Ставлю на сутки, 24 часа (24*60*60 секунд)
    :cookieTime => 24*60*60,

    # Как выглядит :name юзера, user_ + 123
    :name => "user_",
  },

  :games => {
    # Число последних игр, которые грузить на hello#index
    :curGames => 5,

    # Путь к файлу, где дамп для табицы cards_cards.
    # типа такой:
    #   Cards::Engine.root + это
    #   C:/ruby/Sites/engines/cards + /db/__data/cards_dump.txt
    :cards_dump_path => "/db/__data/cards_dump.txt",

    # Количество карт на раздачу
    :nCards4Hand => 10,

    # Как выглядит ключ игры. Типа /game_ + 12345
    :gamekey => "game_",

    # Время, сколько юзер считается онлайн. 10 минут (600 сек)
    :uTime => 600,
  },

  # Здесь общие настройки движка.
  :general => {
    :dafault_locale => :ru,
  },

  # Переменные, относящиеся к приложению, что хостит данный движок
  :app => {
    :user_model_name => "User",
  },
}
