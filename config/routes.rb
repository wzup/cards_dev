Cards::Engine.routes.draw do
  # get "games/index"
  # get "games/show"
  # get "games/create"
  # get "games/join"
  # get "games/turncard"
  # get "games/pingstate"
  # get "games/destroy"
  # get "games/update"
  # get "hello/index"

  # site.com/ru/game/123 или
  # site.com/game/123
  scope("(:locale)", :locale => /(en|ru)/i) do
    root(:to => "hello#index")
    resources(:games, :only => [:show, :create, :index]) do
      member() do
        get(:pingstate)
        put(:turncard)
        post(:join)
      end
    end
  end
end
