﻿package com.thevillage.Building
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.thevillage.*;
	import com.thevillage.Building.*;
	
	public class Lumbermill extends Building
	{
		
		var tree:ForestTree;
		var currTree:ForestTree;
		var forest:Forest;
		
		public function Lumbermill(type:int, grid:Array, id:int, _gameScreen:GameScreen, _forest:Forest) 
		{
			super(type, grid, id, _gameScreen);
			resType = TileTypes.RESOURCE_WOOD;
			forest = _forest;
			
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init trees
			//initCrop(1, 0);
			
			// init resource
			resource = 0;
			// set rally point
			
			resourceCap = GameData.LUMBERMILL_MAX_STORAGE;
		}
		
		override public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < forest.buildingContent.length ; ind++)
			{
				
				var tree:ForestTree = forest.buildingContent[ind];
				
				if(tree.level < GameData.TREE_RESPAWN_TIME)
				{
					// do nothing				
				}
				
				else if(tree.beingWorked) // tree being worked
				{
					// do nothing
				}
				else if(tree.worker) // tree has a worker (but not being worked)
				{
					if(tree.worker.col == cache_col && tree.worker.row == cache_row && tree.worker.isIdle()) // the minion is ready in the treefield location
					{
						tree.startWork();
					}
					else if(!tree.worker.targetPosition) // the minion isn't on the way (and not in the forest location)
					{
						if(tree.worker.ghostMode) // already assigned to this building probably
						{
							tree.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else if (tree.worker.col == rally_col && tree.worker.row == rally_row) // just got to the rally point after being attached to this treefield
						{
							tree.worker.ghostMode = true;
							tree.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else
						{
							tree.worker.targetPosition = {col: rally_col, row: rally_row};
						}
						
						tree.worker.update();
					}
				}
				else if(workers.length > 0) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							tree.worker = curr_minion;
							tree.parent_building = this;
							//update();
							break;
						}
						
					}
				}
			}
		}
		
		public function treeHarvested()
		{
			resource = resource + GameData.CROP_AMOUNT;
			gameScreen.pickupQuery(this)
		}
	}
}
