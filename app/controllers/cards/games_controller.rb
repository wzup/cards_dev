# coding: utf-8

require_dependency "cards/application_controller"

module Cards
  class GamesController < ApplicationController

    # GET  (/:locale)/games(.:format)
    def index
      # TODO: допилить
    end
  
    # GET  (/:locale)/games/:id(.:format)
    def show

      # Все необходимые переменные для генерации вьюхи games#show
      @plOnl = []
      @me = nil
      @thisGame = nil
      @beginner = nil
      @role = 1
      @cards = []
      @page = ''

      # Ставлю роль
      @me, @role = Game.setRole(request.remote_ip, params[:id])

      # Проверяю, что такая игра вообще существует.
      # Если нет, то заглушка noSuchGame
      # Если есть, то продолжаем
      # where потому что find выбрасывает исключение, а where нет
      @thisGame = Game.where(:id => params[:id]).first
      if(@thisGame.nil?)
        @page = "cards/stubs/stubs"  # ставлю инфу для Спрокета, какие css и js подключать, /folder/file.(js|css)
        @me.update_attribute(:updated_at, Time.now.utc)
        render("cards/stubs/noSuchGame")
        return
      end

      @beginner = @thisGame.user
      @cards = Card.connection.execute("SELECT c.pic, x.pos FROM cards_cards AS c LEFT JOIN cards_game_cards AS x ON x.card_id = c.id WHERE x.game_id = #{@thisGame.id} AND x.isopen = 1 AND x.card_id = c.id").to_a
      rs = GameUser.includes(:user).where(:game_id => @thisGame.id, :updated_at => (Time.now.utc - CARDS_CONF[:games][:uTime])..(Time.now.utc))
      rs.each { |i|
        # Создаю массив игроков. Используется во вьюхе
        @plOnl << i.user
      }

      # Задаю параметр для Спрокета
      @page = "cards/games/show"

      # Для 2-й роли обновляется тоже. Фиксируется активность пользователя на сайте, хоть и не игрок игры.
      if(@role.between?(2,3))
        # Кук самоудалится через сутки
        cookies[:name] = {
          :value => @me.name,
          :domain => request.headers["SERVER_HOSTNAME"],
          :expires => Time.now.utc + CARDS_CONF[:users][:cookieTime]
        }
        @me.update_attribute(:updated_at, Time.now.utc)
      end

      # Обновить время updated_at самой игры.
      # @thisGame.update_attribute(:updated_at, Time.now.utc)

      # Переменная для вьюхи - "начало игры"
      @gameStarted = @thisGame.created_at.strftime("%e %b %Y, " + t("game.at") + " %H:%M")
    end
  

    # POST, (/:locale)/games(.:format), /en/games
    # Создать новую игру и новую раздачу карт. Если игрока не существует, он будет создан.
    # redirect_to games#show, если все ок
    # redirect_to hello#index, если какая-то ошибка
    def create
      begin
        game = Cards::Game.new(:user_ip => request.remote_addr)
        game.save!
      rescue ActiveRecord::ActiveRecordError, Exception
        logger.debug("\n\nERROR:\nwhere: game#create\nwhat_global: #{$!}\nSTACK TRACE:\n#{$@}\n\n")
        # logger.debug("\n\nERROR:\nwhere: game#create\nwhat_global: #{$!}\nwhat_model: #{pp game.errors.inspect}\nSTACK TRACE:\n#{$@}\n\n")
        cookies[:alert] = I18n.t("game.gCreateFail")
        redirect_to(root_url)
      else
        redirect_to(:action => :show, :id => game.id)
      end
    end
  


    # Альтернативная реализация join
    # Когда логика "join" в явной транзакции, реализованой вручную вне модели Game
    def join_alternative
      begin
        Game.joinGame(params[:id], request.remote_ip)
      rescue ActiveRecord::ActiveRecordError, Exception
        logger.debug("\n\nERROR:\nwhere: game#join\nwhat: #{$!}\nSTACK TRACE:\n#{$@}\n\n")
        cookies[:alert] = I18n.t("game.gJoinFail")
        redirect_to(root_url)
      else
        redirect_to(:action => :show, :id => params[:id])
      end
    end
    


    # POST (/:locale)/games/:id/join(.:format), /en/games/123/join
    # Присоединиться к данной игре. Если игрока не существует, он будет создан.
    # redirect_to games#show 
    # Главная реализация join. Когда логика в колбеке Game#before_update, 
    # т.е. внутри модели Game
    def join
      begin
        game = Game.find_or_initialize_by_id(:id => params[:id])
        game.user_ip = request.remote_ip
        game.update_attributes!(:updated_at => Time.now.utc)
      rescue ActiveRecord::ActiveRecordError, Exception
        logger.debug("\n\nERROR:\nwhere: game#join\nwhat: #{$!}\nSTACK TRACE:\n#{$@}\n\n")
        cookies[:alert] = I18n.t("game.gJoinFail")
        redirect_to(root_url)
      else
        redirect_to(:action => :show, :id => params[:id])
      end
    end



    # PUT  (/:locale)/games/:id/turncard(.:format)
    # turncard - обработчик переворота карты. 
    # ОДНА Ф-ИЯ И НА ОТКРЫТЬ И НА ЗАКРЫТЬ
    # Нужно:
    # 1. Обновить в game_cards поле isopen для данной карты. Если пришло 0, поставить 1. И наоборот.
    # 2. Обновить upd_at для:
    #   1. юзера, что кликнул перевернуть карту
    #   2. юзера но в game_users, чтобы зафиксировать, что данный юзер в игре.
    #   3. самой игры в games, фиксирую, что игра активна
    # 3. Сформировать джейсон и вернуть назад pic.
    def turncard
      @me, @role = Game.setRole(request.remote_ip, params[:id])

      # Защита от дурака и обработка случая, когда роль у юзера изменилась с 3 на 2.
      # Это когда он больше 10 мин не кликал по карте, а потом вдруг решил кликнуть.
      # 
      # Только при роль == 3 можно переворачивать карты.
      # Т.е. если роль == 3, то в ДОМ-элемент id="gameInfo" в атрибут data-who
      # ставится число роли. А в __init__ проверяю его. Если не 3, то обработчики
      # на карты не ставятся. И если каким-то образом сюда прийдет вдруг аякс-запрос PUT
      # на переворот карты, то на всякий случай проверю роль.
      # Если не 3, то заглушка feloniousAction "вы делаете какую-то х. Досвидания."
      if(@role != 3)
        respond_to do |format|
          format.json() {
            render(:json => '{
              "status": "500",
              "msg1":' + '"' + t("game.feloniousAction") + '", 
              "msg2":' + '"' + t("game.feloniousAction2") + '"' +
            '}')
            return
          }
        end
      end

      begin
        @card = Game.turncard(@me, @role, params[:id], params[:pos], params[:isopen])
      rescue Exception => e
        # Произошел какой-то сбой при обращении к БД
        respond_to { |format|
          format.json() {
            render(:json => '{}')
          }
        }
      else
        # Если все ок, отправляю ответ
        respond_to { |format|
          format.json() {
            # Была открыта. Я закрыл. Ничего назад отправлять не нужно.
            if(params[:isopen].eql?('1'))
              response.headers['Connection'] = 'Close'
              render(:json => '{"status": "200", "hello": "world"}')
            # Была закрыта. Я открыл. Отправить назад pic.
            elsif(params[:isopen].eql?('0'))
              response.headers['Connection'] = 'Close'
              render(:json => '{
                "status": "200",
                "pic": "' + @card.first.pic + '"}', :content_type => 'text/javascript')
            end
          }
        }
      end
    end
  
    # GET  (/:locale)/games/:id/pingstate(.:format)
    # pingstate - аякс-запрос на состония карт и игроков данной игры. Из баузера отправляется как
    # window.setTimeout(self.card.pingState, 1500); Лезу в БД, извлекаю pos карт, и картинки,
    # если надо, игроков онлайн и возвращаю. А на клиенте эти карты переворачиваются, 
    # игроки обновляются.
    def pingstate
      # На тот случай, если кто-то через урл браузера будет запрашивать. Метод-то GET, надо заглушка.
      # Т.е. если не через Аякс. Роль нужна для заглушки.
      if !request.xhr?
        @me, @role = Game.setRole(request.remote_ip, params[:id])
        response.headers['Connection'] = 'Close'
        @page = "cards/stubs/stubs"
        render("cards/stubs/noSuchPage", :formats => "html")
        return
      end

      # Лезу в БД за состоянием карты данной игры в данный момент
      @cards = Game.connection.execute("SELECT g_c.pos, g_c.isopen AS isopen, (CASE WHEN isopen = 1 THEN c.pic ELSE NULL END) as pic FROM cards_game_cards AS g_c, cards_cards AS c, cards_games AS g WHERE g.id = #{params[:id]} AND g.id = g_c.game_id AND c.id = g_c.card_id ORDER BY pos")
      @plOnl =  Cards.user_class.select([:ip, :name]).joins(:game_users).where("cards_game_users.game_id = ? AND cards_game_users.updated_at BETWEEN ? AND ?", params[:id], Time.now.utc - CARDS_CONF[:games][:uTime], Time.now.utc)

      # debugger
      
      respond_to do |format|
        format.json() {
          response.headers['Connection'] = 'Close'
          # render(:json => '{"pic":"hello"}', :content_type => 'text/javascript')
          render(:json => [@cards, @plOnl], :content_type => 'text/javascript')
        }
      end
    end
  

    def destroy
    end
  
    def update
    end
  end
end
