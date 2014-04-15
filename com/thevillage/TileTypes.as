package com.thevillage {
	
	public class TileTypes {
		
		// Resources
		public static const RESOURCE_WHEAT:int = 1;
		public static const RESOURCE_CHEESE:int = 2;
		public static const RESOURCE_FISH:int = 3;
		public static const RESOURCE_MEAT:int = 4;
		
		public static const RESOURCE_WOOD:int = 5;
		public static const RESOURCE_STONE:int = 6;
		public static const RESOURCE_METAL:int = 7;
		
		public static const RESOURCE_FOOD:int = 8;
		
		// Map Tiles
		public static const MAP_TILE_BASIC:int = 0;
		
		// Buildings 1-30
		
		public static const MANOR_HOUSE:int = 1;
		public static const CROP_FIELD:int = 2;
		public static const STOREHOUSE:int = 3; 
		public static const LUMBERMILL:int = 4; 
		public static const STONECUTTER:int = 5;
		public static const BLACKSMITH:int = 6;
		public static const HUNTER:int = 7;
		public static const FISHERMAN:int = 8;
		public static const PASTURE:int = 9;
		public static const INN:int = 10;
		public static const BONFIRE:int = 11; 
		public static const WALL:int = 12; 
		public static const ARCHER_TURRET:int = 13; 
		public static const GUARD_HOUSE:int = 14; 
		public static const SPIKED_HOLE:int = 15; 
		public static const GATEHOUSE:int = 16; 
		public static const FISHING_CHAIR:int = 17;
		public static const METAL_SHAFT:int = 18;
		public static const TREE:int = 19;
		public static const ANIMAL:int = 19;
		public static const STONE:int = 20;
		
		// Building Strings
		
		public static const MANOR_HOUSE_STR:String = "Manor House";
		public static const CROP_FIELD_STR:String = "Crop Field";
		public static const STOREHOUSE_STR:String = "Storehouse";
		public static const LUMBERMILL_STR:String = "Lumbermill";
		public static const QUARRY_STR:String = "Stonecutter";
		public static const BLACKSMITH_STR:String = "Blacksmith";
		public static const HUNTER_STR:String = "Hunter"; 
		public static const FISHERMAN_STR:String = "Fisherman"; 
		public static const HERDSMAN_STR:String = "Herdsman";
		public static const INN_STR:String = "Inn";
		public static const BONFIRE_STR:String = "Bonfire"; 
		public static const WALL_STR:String = "Wall";
		public static const ARCHER_TURRET_STR:String = "Archer Turret"; 
		public static const GUARD_HOUSE_STR:String = "Guard House"; 
		public static const SPIKED_HOLE_STR:String = "Spiked Hole"; 
		public static const GATEHOUSE_STR:String = "Gatehouse"; 		
		
		// Minions
		
		public static const VILLAGER:int = 101;
		public static const VILLAGER_STR:String = "Villager";
		
		// Misc.
		
			
		public function TileTypes() {
			// constructor code
		}
		
		public static function getItemGridByType(itemType:int):Array
		{
			// inputs building type and outputs building starter grid
			switch(itemType)
			{
				// Buildings
				
				case MANOR_HOUSE:
					return [1,1,1,1];
					break;
				case CROP_FIELD:
					return [1,1,0,0];
					break;
				case STOREHOUSE:
					return [1,1,1,1];
					break;
				case LUMBERMILL:
					return [1];
					break;
				case STONECUTTER:
					return [1];
					break;
				case BLACKSMITH:
					return [1];
					break;
				case HUNTER:
					return [1];
					break;
				case FISHERMAN:
					return [1];
					break;
				case FISHING_CHAIR:
					return [1];
					break;
				case PASTURE:
					return [1];
					break;
				case INN:
					return [1];
					break;
				case BONFIRE:
					return [1];
					break;
				case WALL:
					return [1];
					break;
				case ARCHER_TURRET:
					return [1];
					break;
				case GUARD_HOUSE:
					return [1];
					break;
				case SPIKED_HOLE:
					return [1];
					break;
				case GATEHOUSE:
					return [1];
					break;
				case FISHING_CHAIR:
					return [1]; 
					break;
				
				// Minions
				case VILLAGER:
					return [1];
					break;
				
				default:
					return [1];
					break;
			}
		}
		
		public static function getConstructionMaterials(itemType:int):Array
		{
			// inputs building type and outputs building starter grid
			switch(itemType)
			{
				// Buildings
				
				case MANOR_HOUSE:
					return [80,0,0];
					break;
				case CROP_FIELD:
					return [80,0,0];
					break;
				case STOREHOUSE:
					return [80,0,0];
					break;
				case LUMBERMILL:
					return [80,0,0];
					break;
				case STONECUTTER:
					return [80,0,0];
					break;
				case BLACKSMITH:
					return [80,0,0];
					break;
				case HUNTER:
					return [80,0,0];
					break;
				case FISHERMAN:
					return [80,0,0];
					break;
				case FISHING_CHAIR:
					return [80,0,0];
					break;
				case PASTURE:
					return [80,0,0];
					break;
				case INN:
					return [80,0,0];
					break;
				case BONFIRE:
					return [80,0,0];
					break;
				case WALL:
					return [80,0,0];
					break;
				case ARCHER_TURRET:
					return [80,0,0];
					break;
				case GUARD_HOUSE:
					return [80,0,0];
					break;
				case SPIKED_HOLE:
					return [80,0,0];
					break;
				case GATEHOUSE:
					return [80,0,0];
					break;
				case FISHING_CHAIR:
					return [80,0,0]; 
					break;
				default:
					return [80,0,0];
					break;
			}
		}
		
		public static function getSpeedByType(itemType:int):Number
		{
			// inputs building type and outputs building starter grid
			switch(itemType)
			{
				// Minions
				case VILLAGER:
					return 1;
					break;
				
				default:
					return 0;
					break;
			}
		}
		
		public static function getWorkTimeByType(itemType:int):Number
		{
			// inputs building type and outputs work time in miliseconds
			switch(itemType)
			{
				// Buildings
				
				case CROP_FIELD:
					return 2000;
					break;
				case FISHERMAN:
					return 4000;
					break;
				default:
					return 0;
					break;
			}
		}
		
		public static function itemNameByType(type:int):String
		{
			switch(type)
			{
				// Buildings
				case MANOR_HOUSE:
					return("Manor House");
					break;
				case CROP_FIELD:
					return("Crop Field");
					break;
				case STOREHOUSE:
					return("Storehouse");
					break;
				case LUMBERMILL:
					return("Lumbermill");
					break;
				case STONECUTTER:
					return("Stonecutter");
					break;
				case BLACKSMITH:
					return("Blacksmith");
					break;
				case HUNTER:
					return("Hunter");
					break;
				case FISHERMAN:
					return("Fisherman");
					break;
				case PASTURE:
					return("Herdsman");
					break;
				case INN:
					return("Inn");
					break;
				case BONFIRE:
					return("Bonfire");
					break;
				case WALL:
					return("Wall");
					break;
				case ARCHER_TURRET:
					return("Archer Turret");
					break;
				case GUARD_HOUSE:
					return("Guard House");
					break;
				case SPIKED_HOLE:
					return("Spiked Hole");
					break;
				case GATEHOUSE:
					return("Gatehouse");
					break;
					
				// Minions
				case VILLAGER:
					return("Villager");
					break;
					
				default:
					return("N/A");
					break;
			}
		}
		
		public static function resourceNameByType(type:int):String
		{
			switch(type)
			{
				// Buildings
				case TileTypes.RESOURCE_WHEAT:
					return("crops");
					break;
				case TileTypes.RESOURCE_CHEESE:
					return("cheese");
					break;
				case TileTypes.RESOURCE_FISH:
					return("fish");
					break;
				case TileTypes.RESOURCE_MEAT:
					return("meat");
					break;
				case TileTypes.RESOURCE_WOOD:
					return("wood");
					break;
				case TileTypes.RESOURCE_STONE:
					return("stone");
					break;
				case TileTypes.RESOURCE_MEAT:
					return("meat");
					break;
				case TileTypes.RESOURCE_MEAT:
					return("food");
					break;
				default:
					return("N/A");
					break;
			}
		}
		
		public static function colorByType(type:int):Number
		{
			switch(type)
			{
				// Buildings
				case MANOR_HOUSE:
					return (0x0033FF);
					// manor house - blue
					break;
				case CROP_FIELD:
					return (0xFFFF00)
					// crop field - yellow
					break;
				case STOREHOUSE:
					return (0x00cc33)
					// storehouse - green
					break;
				case LUMBERMILL:
					return (0x996633)
					// Lumbermill - brown
					break;
				case STONECUTTER:
					return (0xcccccc)
					// Querry - grey
					break;
				case BLACKSMITH:
					return (0x00ccFF)
					// Mine - light blue
					break;
				case HUNTER:
					return (0xFF0000);
					// hunter - red
					break;
				case FISHERMAN:
					return (0x009966)
					// fisherman - dark turkiz
					break;
				case PASTURE:
					return (0x009966)
					// herdsman - dark green
					break;
				case INN:
					return (0xFF9900)
					// inn - orange
					break;
				case BONFIRE:
					return (0xFFFF99)
					// Bonfire - light yellow
					break;
				case WALL:
					return (0xcccc99)
					// Wall - army green
					break;
				case ARCHER_TURRET:
					return (0x990033)
					// Archer turret - dark red
					break;
				case GUARD_HOUSE:
					return (0x66FFcc)
					// Guardhouse - Light turkiz
					break;
				case SPIKED_HOLE:
					return (0xFF00cc)
					// Spiked hole - pink
					break;
				case GATEHOUSE:
					return (0x9900cc)
					// GateHouse - purple
					break;
					
				// Minions
				case VILLAGER:
					return(0x555555);
					break;
					
				default:
					return (0x000000);
					// default - black
					break;
			}
		}
	}
	
}
