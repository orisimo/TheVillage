package com.thevillage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.thevillage.GameData;
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
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// set rally point
			rally_col = col + 1;
			rally_row = row + 2;
			
			trace(col, row, rally_col, rally_row);
		}
		
		override public function drawItem()
		{
			super.drawItem();
			
			// rally point art
			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable, true);
			addChild(newSprite);
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
