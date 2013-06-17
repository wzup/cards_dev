# coding: utf-8

class User < ActiveRecord::Base
  
  # ВООБЩЕ-ТО В ЭТОЙ РЕАЛИЗАЦИИ ПРИЛОЖЕНИЯ name ВООБЩЕ НЕ НУЖЕН. 
  # ДЕЛАЮ, МОЖЕТ ПОТОМ ПРИГОДИТСЯ.
  attr_accessible :ip, :name


  # :name не делаю обязательным. В модели :null => true
  # Для чего см. after_create. Т.к. name апдейтится после уже получения id
  validates(:ip, :presence => true)
  validates(:id, :ip, :uniqueness => true)


  # Задаю ассоциации. Для модели User Их две:
  # 1. Юзер - только один юзер-игрок может быть бегиннером данной игры.
  # 2. Юзер - множество юзеров-игроков могут быть участниками данно игры, ЧЕРЕЗ game_users таблицу.
  has_one(:game, :class_name => Cards::Game)


  #   !!!!! В :through указывается не имя таблицы-ассоциации, а имя МОДЕЛИ-ассоциации !!!!!
  has_many(:games,
    :through => :game_users, 
    :class_name => Cards::Game,
    :order => "id DESC",
    # :include => :game,
  )
  has_many(:game_users, :class_name => Cards::GameUser)



  # Такой себе флаг, что новый юзер был создан, см. after_create. Проверяю флаг в games#create
  # Если тру, то обновлять updated_at не надо, т.к. при создании юзера updated_at уже обновлен.
  # Если nil, то надо, т.к. юзер не создался надо обновить существующему updated_at.
  attr_accessor(:isNew)


  # Цель: число в :name (user_123) должно соответствовать serial из таблицы.
  # Для этого делаю такой финт ушами. Сначала происходит create нового юзера. 
  # А затем в этом методе, after_create, достаю полученный id и апдейтю поле :name.
  # В дыбильной postgresql это похоже единственный вменяемый вариант.
  # То же самое в Cards::Game (т.е. в энджине)
  after_create() do |user|
    user.update_attribute(:name, APP_CONF[:users][:name] + user.id.to_s)
  end


  # Только, если новый юзер создается, этот флаг установится.
  # Если он есть, то updated_at юзера в games#create не обновляется. Т.к. при создании юзера поле уже обновилось.
  # Это чтобы не гонять там зря туда-сюда запрос к БД.
  after_create() { |user|
    user.isNew=(true)
    puts "\nBINGO, YOU'VE CREATED A NEW USER.\n\n"
  }  
end
