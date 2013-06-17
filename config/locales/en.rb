# coding: utf-8
{
	:en => {
		# hello - страница /
		:hello => {
			:tjOfSite1 => "The test job behind this site",
			:gamesToJoin => "These are the latest five games. Choose a one to join (neither new hand nor game is generated)",
			:startGame1 => "A button click generates a new hand of cards, and consequently a brand-new game.",
			:welcomeTxt1 => "This superb awesome site on Rails imitates a card game site. Create a new game or join an existing one.",
			:crNewGameError => "An unexpected error happened during new game creation. Please, try again.",
			:sg => "Start a new game", # start game
			:welcomeTxt2 => 'Why this site in general',
			:welcomeTxt3 => 'To demonstrate a working knowledge of Ruby.',
			:welcomeTxt4 => 'To demonstrate Ruby on Rails usage skills for web-development.',
			:welcomeTxt5 => 'To demonstrate the exposure to Heroku and knowledge of how to deploy apps with it.',
			:welcomeTxt6 => 'To demonstrate the exposure to other technologies, standards and dev principles: JavaScript, jQuery, CSS3, HTML5, RegExp, ActiveRecord, MVC, RESTful, I18n, SQL, OOP, ImageMagick, OSI model, and etc., etc., etc.',
			:welcomeTxt7 => 'To demonstrate English speaking skills.',
	   },
		:game => {
			:gameWord => "Game ", # game-a
			:whoStartedGame => "Game started by: ", # game started by
			:you => "You",
			:st_at => " started: ", # started at
			:part => "Participants: ", # participate
			:at => "at", # для "20-04-2013, в 10:10"
			:sorry => "Sorry,",
			:nobody => "Nobody at the moment.",
			:feloniousAction => "As you have not turned over any card during last #{CARDS_CONF[:games][:uTime]} minutes, it is considered that you have left the game. ",
			:feloniousAction2 => "To join this game again, you can click this link:",
      :feloniousAction2 => "Чтобы снова стать учстником именно этой игры, кликните ссылку:",
			:gCreateFail => "An unexpected error happened during new game creation process. Please, start a new game one more time.",
			:gJoinFail => "An unexpected error happened during join game process. Please, repeat the action one more time.",
			:na => "A reminder: to turn over the cards you need either to join a geme or to start a new one.", # not auth
			:toRegLoginPage => "Go to start page",
			:toGameIndex => "To see all the games",
		},
		:stubs => {
			:opa => "Oops!",
			:butUcan => "Nevertheless, you can: ",
			:noSuchUser => "There is no user here you're requesting. Maybe she will appear in the future, but we do not recomend you to wait.", 
			:noSuchGame => "We have no such a game yet.",
			:regAndCreate => "Nevertheless, you can log in and start a new game or join one of the existing games.",
			:loginAndBrowse => "Nevertheless, you can log in and browse here by yourself.",
			:startNewFromYourProfile => "Nevertheless, you can start a new game or join one of the existing games from within your profile.",
			:gamePlayed => "This game has been played already. It is no more active.",
			:goToYourProf => "Go back to your profile",
			:goBackToRootPage => "Go to login and registration page",
			:goToRootPage => "Go to login and registration page",
			:haveToBePlayer => "You must be a participant of the game. Sorry.",
			:noEditPage3_1 => "Yes, that's right, your profile's settings page should be here.",
			:noEditPage3_2 => "But since this is a demo site, it is absent.",
			:noEditPage2_1 => "We are sorry, but you cannot get the settings page of profile that is not yours.",
			:noEditPage2_2 => "You wouldn't like if someone could change your profile's settings without your permission.",
			:noEditPage1_1 => "Yes, that's right, a profile settings page should be here.",
			:noSuchPage => "Unfortunately we must admit that there is no such a page on this site.",
			:goToStartPage => "Go to start page",
			:goToPrevPage => "Go back to previous page",
		},
	},
}