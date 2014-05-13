package com.thevillage.Building
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.thevillage.*;
	import com.thevillage.Building.*;
	import flash.display.Sprite;
	
	public class CropField extends Building
	{
		
		var crop:Crop;
		var currCrop:Crop;
		
		public function CropField(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			resType = TileTypes.RESOURCE_WHEAT;
			
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
		}
		
		override public function initBuilding()
		{
			// init crops
			buildingContent = new Array();
			
			initCrop(1, 0);
			
			super.initBuilding();
			
			// init resource
			resource = 0;
			
			// set rally point
			resourceCap = GameData.CROPFIELD_MAX_STORAGE;
		}
		
		private function initCrop(add_col:int, add_row:int)
		{
			var crop_col:int = col + add_col;
			var crop_row = row + add_row;
			
			crop = new Crop(this, crop_col, crop_row);
			buildingContent.push(crop)
		}
		
		override public function update()
		{
			super.update();
			
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
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							crop.worker = curr_minion;
							//update();
							break;
						}
						
					}
				}
			}
		}
		
		override public function drawItem()
		{
			super.drawItem();
			
			if(isPlaced && !underConstruction)
			{
				// Now put any extra art that is specific to this bulding (not rally)
				for (var i:int = 0; i < buildingContent.length; i++)
				{					
					var newSprite:TileSprite = new TileSprite(TileTypes.CROP, 0);
					newSprite.art.gotoAndStop(int(Math.random()*4+1));
					newSprite.x = -x + buildingContent[i].col*GameData.TILE_SIZE;
					newSprite.y = -y + buildingContent[i].row*GameData.TILE_SIZE;
					addChild(newSprite);
					spriteArray.push(newSprite);
				}
			}
			
			
		}
		
		public function cropHarvested()
		{
			changeResourceAmount(GameData.CROP_AMOUNT);
			gameScreen.pickupQuery(this)
		}
	}
}
