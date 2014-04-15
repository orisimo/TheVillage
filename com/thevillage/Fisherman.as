﻿package com.thevillage 
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.thevillage.GameData;
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
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init fishingChairs
			// initChair(1, 0);
			
			// init resource
			resource = 0;
			
			// set rally point
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 1;
			
			resourceCap = GameData.FISHERMAN_MAX_STORAGE;
		}
			
		override public function drawItem()
		{
			super.drawItem();
			
			// rally point art
			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable, true);
			addChild(newSprite);
			
			// first fishingChair
			
			//trace(TileTypes.FISHING_CHAIR);
			trace(gameScreen);
			gameScreen.callAddItem(TileTypes.FISHING_CHAIR, this);
			
			
			
			
			
			//e.target.dispatchEvent(new GameEvent(GameEvent.ADD_ITEM_EVENT, TileTypes.F, true));
			/*
			var chair_col:int = col+1;
			var chair_row:int = row;
			
			newSprite = new TileSprite(itemType, positionAvailable);
			newSprite.x = GameData.TILE_SIZE;
			
			addChild(newSprite);
			
			*/
			
			
			
			
			/*for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				if(itemGrid[ind])
				{
					var chair_col:int = col + ind%Math.sqrt(itemGrid.length);
					var chair_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
				
					fishingChair = new Crop(this, chair_col, chair_row);
					buildingContent.push(fishingChair);
				}
			}*/
		}
		
		private function initChair(add_col:int, add_row:int)
		{
			
			/*
			
			var chair_col:int = col + add_col;
			var chair_row = row + add_row;
			
			fishingChair = new FishingChair(this, chair_col, chair_row);
			buildingContent.push(fishingChair);
			*/
		
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
			changeResourceAmount(GameData.CROP_AMOUNT);
			gameScreen.pickupQuery(this)
		}
	}
}
