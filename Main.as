package  {
	
	import flash.display.MovieClip;
	import com.thevillage.GameUI;
	import com.thevillage.Building;
	import com.thevillage.GameScreen;
	import flash.geom.Point;
	
	public class Main extends MovieClip {
		
		var gameUI:GameUI;
		var screen:GameScreen;
		
		
		
		public function Main() 
		{
			gameUI = new GameUI(food_btn, villagers_btn, train_btn, build_btn, resource_panel);
			screen = new GameScreen(gameUI);
			
			addChild(screen);
			addChild(gameUI);
		}
	}
	
	
}
