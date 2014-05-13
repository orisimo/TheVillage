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
	
	public class Fisherman extends Building
	{
		
		var fishingChair:FishingChair;
		var currChair:FishingChair;
		
		public function Fisherman (type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			
			super(type, grid, id, _gameScreen);
				
	
			resType = TileTypes.RESOURCE_FISH;
			
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 1;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			// init resource
			resource = 0;
			
			resourceCap = GameData.FISHERMAN_MAX_STORAGE;
		}
		
		override public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var fishingChair:FishingChair = buildingContent[ind];
				
				if(fishingChair.beingWorked) // fishingChair being worked
				{
					// do nothing
				}
				else if(fishingChair.worker) // fishingChair has a worker (but not being worked)
				{
					if(fishingChair.worker.col == fishingChair.col && fishingChair.worker.row == fishingChair.row && fishingChair.worker.isIdle()) // the minion is ready in the cropfield location
					{
						fishingChair.startWork();
					}
					else if(!fishingChair.worker.targetPosition) // the minion isn't on the way (and not in the fishingChairfield location)
					{
						fishingChair.worker.targetPosition = {col: fishingChair.col, row: fishingChair.row};
						
						fishingChair.worker.update();
					}
				}
				else if(workers.length > 0) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							fishingChair.worker = curr_minion;
							//update();
							break;
						}
						
					}
				}
			}
		}
		
		public function fishHarvested()
		{
			changeResourceAmount(GameData.FISH_AMOUNT);
			gameScreen.pickupQuery(this)
		}
	}
}
