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
	
	public class Pasture extends Building
	{
		
		var pen:Pen;
		var currPen:Pen;
		
		public function Pasture (type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			super(type, grid, id, _gameScreen);
			resType = TileTypes.RESOURCE_CHEESE;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init pens
			initPen(1, 0);
			
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
			
			// first pen
			var pen_col:int = col+1;
			var pen_row:int = row;
			
			newSprite = new TileSprite(itemType, positionAvailable);
			newSprite.x = GameData.TILE_SIZE;
			
			addChild(newSprite);
			
			/*for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				if(itemGrid[ind])
				{
					var pen_col:int = col + ind%Math.sqrt(itemGrid.length);
					var pen_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
				
					pen = new Pen(this, pen_col, pen_row);
					buildingContent.push(pen);
				}
			}*/
		}
		
		private function initPen (add_col:int, add_row:int)
		{
			var pen_col:int = col + add_col;
			var pen_row = row + add_row;
			
			pen = new Pen(this, pen_col, pen_row);
			buildingContent.push(pen);
		}
		
		override public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < buildingContent.length ; ind++)
			{
				var pen:Pen = buildingContent[ind];
				
				if(pen.level < 6) // pen not ready
				{
					pen.level++;
				}
				else if(pen.beingWorked) // pen being worked
				{
					// do nothing
				}
				else if(pen.worker) // pen has a worker (but not being woreked)
				{
					if(pen.worker.col == rally_col && pen.worker.row == rally_row && pen.worker.isIdle()) // the minion is in the penfield location
					{
						pen.startWork();
					}
					else if(!pen.worker.targetPosition) // the minion isn't on the way (and not in the pasture location)
					{
						if(pen.worker.ghostMode) // already assigned to this building probably
						{
							pen.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else if (pen.worker.col == rally_col && pen.worker.row == rally_row) // just got to the rally point after being attached to this penfield
						{
							pen.worker.ghostMode = true;
							pen.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else
						{
							pen.worker.targetPosition = {col: rally_col, row: rally_row};
						}
						
						pen.worker.update();
					}
				}
				else if(workers.length > 0 ) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							pen.worker = curr_minion;
							//update();
							break;
						}
					}
				}
			}
		}
		
		public function penHarvested()
		{
			resource = resource + GameData.PEN_AMOUNT;
			gameScreen.pickupQuery(this)
		}
	}
}
