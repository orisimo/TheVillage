﻿﻿package com.thevillage {
	
	public class GameData {
		
		public static const TILE_SIZE:int = 28;
		public static const GRID_WIDTH:int = 25;
		public static const GRID_HEIGHT:int = 18;
		
		public static const GRID_COLOR:Number = 0x000000;
		public static const GRID_ALPHA:Number = 0.5;
		
		public static const TICK_TIME:Number = 500; // miliseconds
		public static const BUILDING_TICK:Number = 500; // miliseconds
		public static const CONSTRUCTION_TICK:Number = 1000; // miliseconds
		public static const DIAGONAL:Number = Math.sqrt(2);
		
		public static const CROP_AMOUNT:int = 10;
		public static const PEN_AMOUNT:int = 10;
		public static const STONE_AMOUNT:int = 10;
		public static const METAL_AMOUNT:int = 10;
		public static const WOOD_AMOUNT:int = 10;
		public static const MEAT_AMOUNT:int = 10;	
		public static const FISH_AMOUNT:int = 10;	
		
		public static const ANIMAL_START_AMOUNT:int = 100;	
		public static const ANIMAL_BIRTH_RATE:int = 50;	
		
		public static const CROPFIELD_MAX_STORAGE:int = 80;
		public static const LUMBERMILL_MAX_STORAGE:int = 80;
		public static const HERDSMAN_MAX_STORAGE:int = 80;
		public static const HUNTER_MAX_STORAGE:int = 80;
		public static const FISHERMAN_MAX_STORAGE:int = 80;
		public static const STONECUTTER_MAX_STORAGE:int = 80;
		public static const BLACKSMITH_MAX_STORAGE:int = 80;
		public static const MAX_HAND_CONTENT:int = 10;
		
		public static const FOREST_NODES:Array = [[18, 0], [19, 0], [20, 0], [21, 0], [22, 0], [23, 0], [24, 0],
												  [18, 1], [19, 1], [20, 1], [21, 1], [22, 1], [23, 1], [24, 1],
												  		   [19, 2], [20, 2], [21, 2], [22, 2], [23, 2], [24, 2],
														   		    [20, 3], [21, 3], [22, 3], [23, 3], [24, 3],
																					  [22, 4], [23, 4], [24, 4]];
		public static const WILDLIFE_NODES:Array = [[21, 0],
												  [23, 1],
												  [19, 2], [22, 2],
												  [20, 3], [24, 3],
												  [22, 4]];
		public static const QUARRY_NODES:Array = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0],
												  [6, 1], [5, 1], [4, 1], [3, 1], [2, 1], [1, 1], [0, 1],
												  		  [5, 2], [4, 2], [3, 2], [2, 2], [1, 2], [0, 2],
														   		  [4, 3], [3, 3], [2, 3], [1, 3], [0, 3],
																				  [2, 4], [1, 4], [0, 4]];
																					  
																					  
		public static const TREE_RESPAWN_TIME:int = 5;
		public static const STONE_RESPAWN_TIME:int = 300;
		public static const SHAFT_RESPAWN_TIME:int = 600;
		
		public static const CROP_RESPAWN_TIME:int = 6;
		public static const SHEEP_RESPAWN_TIME:int = 6;
		
		public static const VILLAGER_FOOD_COST:int = 1;
		public static const FOOD_TICK:int = 10;
		
		
		public function GameData()
		{
			
		}
		
		public static function getResFoodValue(resType:int):int
		{
			switch(resType)
			{
				case TileTypes.RESOURCE_WHEAT:
					return 1;
					break;
				case TileTypes.RESOURCE_CHEESE:
					return 2;
					break;
				case TileTypes.RESOURCE_FISH:
					return 3;
					break;
				case TileTypes.RESOURCE_MEAT:
					return 4;
					break;
				default:
					return NaN;
					break;
			}
		}

	}
	
}