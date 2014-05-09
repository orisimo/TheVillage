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

	public class ManorHouse extends Building
	{


		public function ManorHouse (type:int, grid:Array, id:int, _gameScreen:GameScreen)
		{
			super(type, grid, id, _gameScreen);

		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			
			// set rally point
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
		}
	}
}