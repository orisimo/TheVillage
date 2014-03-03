package com.thevillage
{
	
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class KeyboardController
	{
		var gameScreen:GameScreen;
		
		public function KeyboardController(_gameScreen:GameScreen) 
		{
			gameScreen = _gameScreen;
			initKeyboard();
		}
		
		public function initKeyboard()
		{
			gameScreen.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		}
		
		public function onKeyboardDown(e:KeyboardEvent) 
		{
			//trace(e.keyCode);
			var nudge_dist:int = 8;
			
			switch(e.keyCode)
			{
				case 33: //PgUp
					gameScreen.zoomMap(true);
					break;
				case 34: //PgDn
					gameScreen.zoomMap(false);
					break;
				case 37: //ArrowLeft
					gameScreen.moveMap(nudge_dist,0);
					break;
				case 38: //ArrowUp
					gameScreen.moveMap(0,nudge_dist);
					break;
				case 39: //ArrowRight
					gameScreen.moveMap(-nudge_dist,0);
					break;
				case 40: //ArrowDown
					gameScreen.moveMap(0,-nudge_dist);
					break;
				default:
					break;
			}
		}
	}
	
}
