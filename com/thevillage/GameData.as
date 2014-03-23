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
		public static const PEN_AMOUNT:int = 10;
		
		public static const MAX_CROPFIELD_STORAGE:int = 80;
		public static const MAX_HAND_CONTENT:int = 10;
		
		public static const FOREST_NODES:Array = [[18, 0], [19, 0], [20, 0], [21, 0], [22, 0], [23, 0], [24, 0],
												  [18, 1], [19, 1], [20, 1], [21, 1], [22, 1], [23, 1], [24, 1],
												  		   [19, 2], [20, 2], [21, 2], [22, 2], [23, 2], [24, 2],
														   		    [20, 3], [21, 3], [22, 3], [23, 3], [24, 3],
																					  [22, 2], [23, 2], [24, 2],
		
		public function GameData()
		{
			
		}

	}
	
}
