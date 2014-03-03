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
		
		public function CropField(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init crops
			for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				if(itemGrid[ind])
				{
					var crop_col:int = col + ind%Math.sqrt(itemGrid.length);
					var crop_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
				
					crop = new Crop(this, crop_col, crop_row);
					buildingContent.push(crop);
				}
			}
			
			// init resource
			resource = 0;
			
			// set rally point
			rally_col = col + 0;
			rally_row = row + 1;
		}
		
		override public function update()
		{
			super.update();
			
			
			//trace("update");
			// handle crops
			
			//trace("my workers: "+workers);
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var crop:Crop = buildingContent[ind];
				
				//trace("being worked: "+crop.beingWorked);
				//trace("crop "+String(ind)+" level: "+crop.level);
				if(crop.level < 6) // crop not ready
				{
					crop.level++;
				}
				else if(crop.beingWorked)
				{
					// do nothing
				}
				else if(crop.worker)
				{
					//trace("minion: "+crop.worker.col, crop.worker.row)
					//trace("crop: "+crop.col, crop.row)
					if(crop.worker.col == rally_col && crop.worker.row == rally_row && crop.worker.isIdle()) // the minion is in the cropfield location
					{
						crop.startWork();
					}
					else if(!crop.worker.targetPosition) // the minion isn't in the cropfield location and not on the way
					{
						//trace("the minion is somewhere else");
						//trace("set target position to here: "+crop.col+" "+crop.row);
						crop.worker.targetPosition = {col: rally_col, row: rally_row};
						crop.worker.update();
					}
					// already has a worker. do nothing
				}
				else if(workers) // we have some minions to work the field
				{
					//trace("workers: "+workers);
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++)
					{
						var curr_minion:Minion = workers[minion_ind];
						//trace("curr_minion.readyToWork: "+curr_minion.readyToWork);
						if(!curr_minion.isAssigned)
						{
							//trace("got a ready minion");
							crop.worker = curr_minion;
							crop.worker.isAssigned = true;
							update();
							break;
						}
						
					}
				}
			}
		}
		
		public function cropHarvested()
		{
			changeResourceAmount(GameData.CROP_AMOUNT);
		}
	}
}
