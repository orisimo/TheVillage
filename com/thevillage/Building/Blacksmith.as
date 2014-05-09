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
	
	public class Blacksmith extends Building
	{
		
		var metalShaft:MetalShaft;
		var currShaft:MetalShaft;
		
		public function Blacksmith (type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
				
			resType = TileTypes.RESOURCE_METAL;
			
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init resource
			resource = 0;
			
			resourceCap = GameData.BLACKSMITH_MAX_STORAGE;
		}
		
		override public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var metalShaft:MetalShaft = buildingContent[ind];
				
				if(metalShaft.level < 6) // metalShaft not ready
				{
					metalShaft.level++;
				}
				else if(metalShaft.beingWorked) // metalShaft being worked
				{
					// do nothing
				}
				else if(metalShaft.worker) // metalShaft has a worker (but not being woreked)
				{
					if(metalShaft.worker.col == rally_col && metalShaft.worker.row == rally_row && metalShaft.worker.isIdle()) // the minion is in the fisherman location
					{
						metalShaft.startWork();
					}
					else if(!metalShaft.worker.targetPosition) // the minion isn't on the way (and not in the fisherman location)
					{
						metalShaft.worker.targetPosition = {col: rally_col, row: rally_row};
						metalShaft.worker.update();
					}
				}
				else if(workers) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							metalShaft.worker = curr_minion;
							break;
						}
					}
				}
			}
		}
		
		public function metalHarvested()
		{
			resource = resource + GameData.METAL_AMOUNT;
			gameScreen.pickupQuery(this)
		}
	}
}
