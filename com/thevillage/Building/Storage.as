package com.thevillage.Building
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.thevillage.GameData;
	import com.thevillage.GameScreen;
	import com.thevillage.TileSprite;
	import com.thevillage.TileTypes;
	import com.thevillage.Minion;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Storage extends Building
	{
		public function Storage(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			// set rally point
			rally_col = col + 1;
			rally_row = row + 2;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			
			trace("storage rally point: "+rally_col, rally_row);
		}
		
		override public function update()
		{
			super.update();
			
			
			//trace("update");
			// handle crops
			
			//trace("my workers: "+workers);
		}
	}
}
