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
	
	public class CropField extends Building
	{
		
		var crop:Crop;
		var currCrop:Crop;
		
		public function CropField(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			resType = TileTypes.RESOURCE_WHEAT;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init crops
			initCrop(1, 0);
			
			// init resource
			resource = 0;
			
			// set rally point
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
		}
			
		override public function drawItem()
		{
			super.drawItem();
			
			// rally point art
			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable, true);
			addChild(newSprite);
			
			// first crop
			var crop_col:int = col+1;
			var crop_row:int = row;
			
			newSprite = new TileSprite(itemType, positionAvailable);
			newSprite.x = GameData.TILE_SIZE;
			
			addChild(newSprite);
			
			/*for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				if(itemGrid[ind])
				{
					var crop_col:int = col + ind%Math.sqrt(itemGrid.length);
					var crop_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
				
					crop = new Crop(this, crop_col, crop_row);
					buildingContent.push(crop);
				}
			}*/
		}
		
		private function initCrop(add_col:int, add_row:int)
		{
			var crop_col:int = col + add_col;
			var crop_row = row + add_row;
			
			crop = new Crop(this, crop_col, crop_row);
			buildingContent.push(crop);
		}
		
		override public function update()
		{
			super.update();
			
			trace("my workers: "+workers);
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var crop:Crop = buildingContent[ind];
				
				if(crop.level < 6) // crop not ready
				{
					crop.level++;
				}
				else if(crop.beingWorked) // crop being worked
				{
					// do nothing
				}
				else if(crop.worker) // crop has a worker (but not being worked)
				{
					if(crop.worker.col == cache_col && crop.worker.row == cache_row && crop.worker.isIdle()) // the minion is ready in the cropfield location
					{
						crop.startWork();
					}
					else if(!crop.worker.targetPosition) // the minion isn't on the way (and not in the cropfield location)
					{
						if(crop.worker.ghostMode) // already assigned to this building probably
						{
							crop.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else if (crop.worker.col == rally_col && crop.worker.row == rally_row) // just got to the rally point after being attached to this cropfield
						{
							crop.worker.ghostMode = true;
							crop.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else
						{
							crop.worker.targetPosition = {col: rally_col, row: rally_row};
						}
						
						crop.worker.update();
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
							crop.worker = curr_minion;
							//update();
							break;
						}
						
					}
				}
			}
		}
		
		public function cropHarvested()
		{
			resource = resource + GameData.CROP_AMOUNT;
			gameScreen.pickupQuery(this)
		}
	}
}
