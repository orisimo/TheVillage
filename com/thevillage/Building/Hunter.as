﻿package com.thevillage.Building
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.thevillage.*;
	import com.thevillage.Building.*;
	
	public class Hunter extends Building
	{
		
		var animal:Animal;
		var wildlife:Wildlife;
		
		public function Hunter(type:int, grid:Array, id:int, _gameScreen:GameScreen, _wildlife:Wildlife) 
		{
			super(type, grid, id, _gameScreen);
			resType = TileTypes.RESOURCE_MEAT;
			wildlife = _wildlife;
			
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
			
			resourceCap = GameData.HUNTER_MAX_STORAGE;
		}
		
		override public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < wildlife.buildingContent.length ; ind++)
			{
				
				var animal:Animal = wildlife.buildingContent[ind];
				trace("animalevel: "+animal.level);
				if(animal.level < GameData.ANIMAL_BIRTH_RATE)
				{
					// do nothing				
				}
				
				else if(animal.beingWorked) // animal being worked
				{
					// do nothing
				}
				else if(animal.worker) // animal has a worker (but not being worked)
				{
					if(animal.worker.col == cache_col && animal.worker.row == cache_row && animal.worker.isIdle()) // the minion is ready in the animalfield location
					{
						animal.startWork();
					}
					else if(!animal.worker.targetPosition) // the minion isn't on the way (and not in the wildlife location)
					{
						if(animal.worker.ghostMode) // already assigned to this building probably
						{
							animal.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else if (animal.worker.col == rally_col && animal.worker.row == rally_row) // just got to the rally point after being attached to this animalfield
						{
							//animal.worker.ghostMode = true;
							animal.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else
						{
							animal.worker.targetPosition = {col: rally_col, row: rally_row};
						}
						
						animal.worker.update();
					}
				}
				else if(workers.length > 0) // we have some minions to work the field
				{
					trace("we have workers");
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							trace("assigning");
							animal.worker = curr_minion;
							animal.parent_hunter = this;
							//update();
							break;
						}
						
					}
				}
			}
		}
		
		public function animalHarvested()
		{
			resource = resource + GameData.MEAT_AMOUNT;
			gameScreen.pickupQuery(this)
		}
	}
}
