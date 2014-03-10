﻿package com.thevillage {
	
	public class GameData {
		
		public static const TILE_SIZE:int = 28;
		public static const GRID_WIDTH:int = 25;
		public static const GRID_HEIGHT:int = 18;
		
		public static const GRID_COLOR:Number = 0x000000;
		public static const GRID_ALPHA:Number = 0.5;
		
		public static const TICK_TIME:Number = 500; // miliseconds
		public static const BUILDING_TICK:Number = 500; // miliseconds
		public static const DIAGONAL:Number = Math.sqrt(2);
		
		public static const CROP_AMOUNT:int = 10;
		
		public static const MAX_CROPFIELD_STORAGE:int = 80;
		public static const MAX_HAND_CONTENT:int = 10;
		
		public function GameData()
		{
			
		}

	}
	
}
