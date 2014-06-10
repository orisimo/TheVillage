package com.thevillage.Building
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.thevillage.*;
	import com.thevillage.Building.*;
	import flash.display.Sprite;
	
	public class House extends Building
	{
		public function House(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
		}
		
		override public function initBuilding()
		{
			// init crops
			buildingContent = new Array();
			super.initBuilding();
			
			gameScreen.placeItem(gameScreen.createItem(TileTypes.VILLAGER,[col, row]));
			
		}
		
		override public function drawItem()
		{
			super.drawItem();
			
			if(isPlaced && !underConstruction)
			{
				// Now put any extra art that is specific to this bulding (not rally)
				var newSprite:TileSprite = new TileSprite(TileTypes.HOUSE, 0);
				addChild(newSprite);
				spriteArray.push(newSprite);
			}
		}
	}
}
