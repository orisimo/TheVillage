package com.thevillage 
{
	import com.thevillage.GameData;
	import flash.display.MovieClip;
	
	public class TileSprite extends MovieClip
	{
		
		public function TileSprite(color:Number, spriteAlpha:Number = 1) 
		{
			graphics.beginFill(color, spriteAlpha);
			graphics.drawRect(0, 0, GameData.TILE_SIZE, GameData.TILE_SIZE);
			graphics.endFill();
		}

	}
	
}
