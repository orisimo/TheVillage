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
		
		public function CropField(type:int, grid:Array, id:int) 
		{
			super(type, grid, id);
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init crops
			for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				var crop_col:int = col + ind%Math.sqrt(itemGrid.length);
				var crop_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
			
				crop = new Crop(this, crop_col, crop_row);
				buildingContent.push(crop);
			}
			
			// init resource
			resource = 0;
			
			// set rally point
			rally_col = 0;
			rally_row = 0;
		}
		
		override public function update()
		{
			super.update();
			
			
			trace("update");
			// handle crops
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var crop:Crop = buildingContent[ind];
				
				//trace("my workers: "+workers);
				//trace("being worked: "+crop.beingWorked);
				
				if(crop.level < 3) // crop not ready
				{
					crop.level++;
				}
				else if(!crop.beingWorked && workers) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++)
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.readyToWork)
						{
							if(curr_minion.col == crop.col && curr_minion.row == crop.row) // the minion is in the crop location
							{
								crop.startWork(curr_minion);
							}
							else // the minion is somewhere else
							{
								curr_minion.targetPosition = {col: crop.col, row: crop.row};
							}
							
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
