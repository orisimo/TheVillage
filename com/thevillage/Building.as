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
	
	public class Building extends Item
	{
		public var buildingTimer:Timer;
		
		public var wood:int = 0;
		public var stone:int = 0;
		public var metal:int = 0;
		public var wheat:int = 0;
		public var cheese:int = 0;
		public var fish:int = 0;
		public var meat:int = 0;
		
		public var workers:Array;
		public var buildingContent:Array;
		
		public var allMaterialsComing:Boolean = true;
		public var allMaterialsReady:Boolean = true;
		public var underConstruction:Boolean;
		
		public function Building(type:int, grid:Array, id:int) 
		{
			super(type, grid, id);
			
			update();
			
			buildingTimer = new Timer(GameData.BUILDING_TICK);
			buildingTimer.addEventListener(TimerEvent.TIMER, timerUpdate);
		}
		
		public function timerUpdate(e:TimerEvent)
		{
			update();
		}
		
		public function initBuilding()
		{
			buildingTimer.start();
			buildingContent = [];
			
			switch(itemType)
			{
				// Buildings
				case TileTypes.MANOR_HOUSE:
					return("Manor House");
					break;
				case TileTypes.CROP_FIELD:
					// init crops
					for(var ind:int = 0; ind < itemGrid.length ; ind++)
					{
						var crop:Object = {};
						crop.level = 0;
						crop.col = ind%Math.sqrt(itemGrid.length);
						crop.row = Math.floor(ind/Math.sqrt(itemGrid.length));
						buildingContent.push(crop);
					}
					break;
				default:
					break;
			}
		}
		
		override public function update()
		{
			super.update();
			switch(itemType)
			{
				// Buildings
				case TileTypes.MANOR_HOUSE:
					break;
				case TileTypes.CROP_FIELD:
					// grow crops
					for(var ind:int = 0; ind < buildingContent.length ; ind++)
					{
						var crop:Object = buildingContent[ind];
						if(crop.level < 3) // crop not ready
						{
							crop.level++;
						}
						else if(!crop.worked && workers) // we have some minions to work the field
						{
							for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++)
							{
								var minion:Minion = workers[minion_ind];
								if(minion.readyToWork)
								{
									// get the minion to the crop tile (visual)
									minion.animateMinion(TileTypes.getSpeedByType(TileTypes.VILLAGER), (col+crop.col)*GameData.TILE_SIZE, row+crop.row*GameData.TILE_SIZE);
									
									minion.readyToWork = false;
									crop.workTimer = new Timer(TileTypes.getWorkTimeByType(itemType));
									crop.workTimer.start();
									
									crop.beingWorked = true;
								}
							}
						}
					}
					break;
				case TileTypes.STOREHOUSE:
					return("Storehouse");
					break;
				default:
					break;
			}
		}
	}
}
