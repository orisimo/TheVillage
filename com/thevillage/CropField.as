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
	
	public class CropField extends Building
	{
		var currCrop:Crop;
		var rallyArt:TileSprite;
		
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
			
			// set cache_point
			cache_col = col;
			cache_row = row;
			
			trace(" col and row: "+col, row);
			
			// set rally point
			rally_col = col + 0;
			rally_row = row + 1;
		}
		
		override public function drawItem()
		{
			super.drawItem();
			
			// rally point art
			rallyArt = new TileSprite(itemType, positionAvailable, true);
			addChild(rallyArt);
			
			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable);
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
			var crop_row:int = row + add_row;
			
			crop = new Crop(this, crop_col, crop_row);
			buildingContent.push(crop);
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
					if( ( ( crop.worker.col == rally_col && crop.worker.row == rally_row ) || ( crop.worker.col == cache_col && crop.worker.row == cache_row ) ) && crop.worker.isIdle()) // the minion is in the cropfield rally location
					{
						crop.startWork();
					}
					else if(!crop.worker.targetPosition) // the minion isn't on the way (and not in the cropfield location)
					{
						//trace("send minion to rally");
						crop.worker.targetPosition = {col: rally_col, row: rally_row};
						crop.worker.update();
					}
				}
				else if(workers) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(!curr_minion.isAssigned) // found an available worker
						{
							//trace("got a ready minion");
							crop.worker = curr_minion;
							crop.worker.isAssigned = true;
							ind--;
							break;
						}
						
					}
				}
			}
		}
		
		public function cropHarvested()
		{
			resource = resource + GameData.CROP_AMOUNT;
			var gotoFrame:int = int(resource/GameData.MAX_CROPFIELD_STORAGE*MovieClip(rallyArt.getChildAt(0)).totalFrames)+1;
			//trace("total frames: "+rallyArt.totalFrames);
			//trace("resource: "+resource+" max resource: "+GameData.MAX_CROPFIELD_STORAGE);
			//trace("go to frame: "+ gotoFrame);
			MovieClip(rallyArt.getChildAt(0)).gotoAndStop(gotoFrame);
			gameScreen.pickupQuery(this)
		}
	}
}
