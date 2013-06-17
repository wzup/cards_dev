# coding: utf-8

module Cards
  class Game < ActiveRecord::Base

    attr_accessible(:gamekey, :user_id, :user_ip, :updated_at)

    # Именно таким образом не принадлежащий этой модели внешний параметр,
    # remote_addr, попадает в модель. Есть два варианта:
    # Cards::Game.new({:user_ip => "129.0.0.1"}, :without_protection => true)
    # Cards::Game.new({:user_ip => "129.0.0.1"}), если поставить в attr_accessible
    attr_accessor(:user_ip)


    # :gamekey не делаю обязательным. В миграции :null => true
    # Для чего см. after_create. Т.к. :gamekey апдейтится уже после получения id
    validates(:user_id, :presence => true)


    # Стархуемся: уникальность только пары колонок вместе.
    # Аналогично и в GameUsers.
    validates_uniqueness_of(:gamekey, :scope => :user_id)


    # Задаю ассоциации. Для модели Game из три:
    # 1. Игра - у нее единственный юзер-бегиннер.
    # 2. Игра - у нее множество юзеров-игроков ЧЕРЕЗ game_users таблицу.
    # 3. Игра - у нее множество карт ЧЕРЕЗ game_cards таблицу
    belongs_to(:user, :class_name => Cards.user_class.to_s, :foreign_key => :user_id)


    #   !!!!! В :through указывается не имя таблицы-ассоциации, а имя МОДЕЛИ-ассоциации !!!!!
    # Ассоциация "Игра_игроки"
    # Одна игра имеет много юзеров-игроков, через таблицу game_users
    # Один юзер может одновременно быть игроком во многих играх
    # :dependent => :destroy - удаляю юзера, удаляются что (все игры, где он игрок)? Это глупо!
    has_many(:users, :class_name => Cards.user_class.to_s,
      :through => :game_users,
      :order => "id DESC",
      # :include => :games,
    )
    has_many(:game_users, :class_name => :GameUser)


    # Ассоциация "Игра_карты"
    # Одна игра имеет много карт
    # Она такая же карта может быть во многих играх (но не в одной и той же).
    has_many(:cards, :class_name => :Card, 
      :through => :game_cards, 
      :order => "id DESC"
    )
    has_many(:game_cards)


    # 
    # Типичный рельсовский прием - логику, принадлежащую одной модели,
    # впихивать в совершенно постороннюю модель: Игра создает Игрока.
    # Т.е. идти абсолютно вопреки смыслу паттерна ActiveRecord.
    # 
    # В Яве такой стиль называется Dependency Injection. И НЕ ПРИВЕТСТВУЕТСЯ!
    # В Яве (в Spring) DI заменятся на Inversion of Control. IoC более грамотный подход.
    # Нужно раскидать создаение объектов друг от друга настолько далеко, насколько только возможно и
    # уже созданные объекты (User) передавать в нуждающемуся (Game) через его сеттеры. 
    # А не полностью впихивать логику одного (User) в другое (в Game). Создавать жесткие зависимости - плохо!
    # 
    # Но а в рельсах это считается нормально. Это в рельсах считается "правильный стиль программирования".
    # Ну ок, пишем на рельсах, следуем rails way. Значит: если юзера с данным :ip в БД нет,
    # то модель Games создаст нового юзера. Пффф.
    # 
    # Создает ПЕРЕД ВАЛИДАЦИЕЙ!
    # Именно before_validation, а не before_save. Т.к. валидация идет перед save. А к моменту валидации
    # параметр :user_id уже должеен быть (validates(:user_id, :presence => true))
    # 
    before_validation() do |game|

      self.user = Cards.user_class.find_or_create_by_ip(:ip => user_ip)
    end


    # 1.
    # Первое действие для game create:
    # Цель: число в :gamekey (game_123) должно соответствовать serial из таблицы.
    # Для этого делаю такой финт ушами. Сначала происходит create новой игры. 
    # А затем в этом методе, after_create, достаю полученный id и апдейтю поле :gamekey.
    # В дыбильной postgresql это похоже единственный вменяемый вариант.
    # То же самое в User.
    # 2.
    # Второе действие для game create:
    # - в таблицу game_users заносится данный единственный юзер, первый игрок данной новой игры.
    # 3.
    # Третье действие для game create:
    # - в таблицу game_cards заносится новая раздача карт для данной игры.
    after_create() do |game|

      # puts "\n\n =========== (game) after_create =============== \n\n"

      game.update_attribute(:gamekey, CARDS_CONF[:games][:gamekey] + game.id.to_s)
      # game.game_users.create!(:user_id => game.user.id)
      game.connection().execute(Cards::Game.prepareInsertSql(game.id, 10.randoms_in(1, 54, false)))
      puts "\nBINGO, YOU'VE CREATED A NEW GAME.\n\n"
    end



    # Отработка логики joingame.
    # Т.е. операция UPDATE для модели Game - это есть "присоединить юзера в число игроков"
    # Это главный вариант для games#joingame. Альтернативный вариант - метод self.joinGame.
    before_update() do |game|

      # puts "\n\n =========== (game) before_update =============== \n\n"

      gu = Cards::GameUser.find_or_initialize_by_game_id_and_user_id(:game_id => game.id, :user_id => game.user.id)
      gu.update_attributes!(:updated_at => Time.now.utc)
    end



    # joinGame - присоединиться к игре. Чтобы не засорять контроллер (to keep as it skinny as possible),
    # перенес всю логику данной процедуры в модель.
    # @param game_id string - id данной игры, из params[:id], /en/games/123
    # @param remote_ip string - айпишник юзера, "127.0.0.1"
    def self.joinGame(game_id, remote_ip)

      # Проверяю, есть ли уже такой юзер в БД. 
      #   Если нет, то создать.
      # Проверяю, был ли когда либо данный юзер игроком данной игры, т.е. есть ли он в cards_game_users
      #   Если нет, то создать.
      #   Если есть, то только обновить.
      self.transaction {
        user = Cards.user_class.find_or_create_by_ip(:ip => remote_ip)
        gu = Cards::GameUser.find_or_initialize_by_game_id_and_user_id(:game_id => game_id, :user_id => user.id)
        gu.update_attributes!(:updated_at => Time.now.utc)
      }
    end


    # turncard - перевернуть карту. Опять же, в целях keep controller as skinny as possible
    # переношу логику в модель.
    # @param #<User> me - объект юзер, я, тот, что переворачивает карту
    # @param int role - роль, 1|2|3. Должна всегда быть 3. Если не 3, то юзер делает какую-то шнягу.
    # @param int game_id - params[:id], из урла игры /games/123
    # @param int pos - params[:pos], порядковый номер переворачиваемой карты
    # @param int isopen - 1|0, открытка была какрта или закрыта
    # @return #<User> card - возвращаю карту для возврата ответа аякса в браузер. Чтобы иметь картинку
    def self.turncard(me, role, game_id, pos, isopen)

      self.transaction() {
        # Получаю ту самую карту, которую перевернули. Нужна ее картинка pic, чтобы отправить назад.
        # join-запрос по game_cards.game_id и game_cards.pos
        @card = Cards::Card.joins(:game_cards).where("cards_game_cards.game_id = ? AND cards_game_cards.pos = ?", game_id, pos)

        # Меняю значеие isopen. Т.е. меняестся 1 на 0 или наоборот.
        # В аяксе приходит то, что было. Следовательно ставить противоположное.
        isopen = (isopen.eql?('1')) ? 0 : 1
        @card.first.game_cards.where(:game_id => game_id).first.update_attribute(:isopen, isopen)

        # Обновляю активность, т.е. updated_at:
        # 1. юзера, что кликнул перевернуть карту
        # 2. его же, но в таб. game_users, чтобы зафиксировать, что данный юзер в игре.
        # 3. самой игры, в games, фиксирую, что игра активна
        me.update_attribute(:updated_at, Time.now.utc)
        me.game_users.where(:game_id => game_id).first.update_attribute(:updated_at, Time.now.utc)
        self.find(game_id).update_attribute(:updated_at, Time.now.utc)
      }
      return @card
    end



    # setRole - установить роль. 
    # Вызываю метод явно и только там, где нужно, а не везде.
    # Важно. Отсюда может выйти роль 1 и 2, а в контроллере уже станет 3 (присоединение или регистрация нового юзера).
    # role 1 - гость. Нет в БД, и естественно не игрок никакой игры.
    # role 2 - юзер. Есть в БД, но не онлайн-игрок данной игры.
    # role 3 - игрок. Есть в БД и онлайн-игрок конкретной игры.
    # @param remote_ip string - это request.remote_ip. ip в БД уникальный. по нему определяю, есть ли в БД позьзователь.
    # @param game_id string | int - это :id игры из урла /games/12345
    # @return #<User> | nil && int - юзер - это @me и роль 1|2|3
    def self.setRole(remote_ip, game_id)
      user = User.find_by_ip(remote_ip)
      # Роль == 1, юзер - nil. Нет в БД.
      if(user.nil?)
        return user, 1
      end

      # Роль == 3. Юзер - игрок данной игры.
      # Определяю, есть ли в числе активных игроков данной игры данный юзер
      # game_users.updated_at <= 600 секунд
      # rs - ActiveRecord::Relation
      rs = user.game_users.where(:game_id => game_id, :updated_at => ((Time.now.utc - CARDS_CONF[:games][:uTime])..Time.now.utc))
      if(rs.any?)
        return user, 3
      end

      # Роль == 2. Юзер - не игрок данной игры, но в БД есть.
      return user, 2
    end


    private
      # 
      # prepareInsertSql - длинное INSERT sql-предложение.
      # Для запсиси в cards_game_cards раздачи 10-ти карт данной игры.
      # Выглядит:
      #     INSERT INTO cards_game_cards (game_id, card_id, pos) 
      #       VALUES (1, 1, 0, NOW(), NOW()), (1, 25, 1, NOW(), NOW()), ...
      # 
      # Чисто domain-specific функция. Нет смысла выносить в плагин или джем.
      # 
      # Практически, это действие - insert новой раздачи в cards_game_cards - можно было
      # решить обычным rails-блоком. Но тогда было бы 10 обращений к БД. Чтобы этого избежать,
      # делаю одно предложение и тогда все делаю в одно единственное обращение к БД.
      # 
      # @param cards [] - массив раздачи карт, после Game#genHand
      # @param gameId int|string - id игры
      # @return string - готовое sql
      def self.prepareInsertSql(gameId, cards)
        sql = "INSERT INTO cards_game_cards (game_id, card_id, pos, created_at, updated_at) VALUES ";
        cards.each.each_with_index { |i, n|
          sql += "(#{gameId}, #{i}, #{n}, NOW(), NOW())";
          if n != 9
            sql += ", ";
          end
        }
        return sql + ";"
      end    
  end
end
