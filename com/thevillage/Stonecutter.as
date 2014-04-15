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
	
	public class Stonecutter extends Building
	{
		
		var rock:QuarryStone;
		var currStone:QuarryStone;
		var quarry:Quarry;
		
		public function Stonecutter(type:int, grid:Array, id:int, _gameScreen:GameScreen, _quarry:Quarry) 
		{
			super(type, grid, id, _gameScreen);
			resType = TileTypes.RESOURCE_STONE;
			quarry = _quarry;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init rocks
			//initCrop(1, 0);
			
			
			// init resource
			resource = 0;
			
			// set rally point
			rally_col = col + 0;
			rally_row = row + 1;
			
			cache_col = col + 0;
			cache_row = row + 0;
			
			resourceCap = GameData.STONECUTTER_MAX_STORAGE;
			
			
		}
			
		override public function drawItem()
		{
			super.drawItem();
			
			// rally point art
			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable, true);
			addChild(newSprite);
			
			// first rock
			//var rock_col:int = col+1;
			//var rock_row:int = row;
			
			/*
			
			newSprite = new TileSprite(itemType, positionAvailable);
			newSprite.x = GameData.TILE_SIZE;
			
			addChild(newSprite);
			
			*/
			
			/*for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				if(itemGrid[ind])
				{
					var rock_col:int = col + ind%Math.sqrt(itemGrid.length);
					var rock_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
				
					rock = new Crop(this, rock_col, rock_row);
					buildingContent.push(rock);
				}
			}*/
		}
		
		
		override public function update()
		{
			super.update();
			
			for(var ind:int = 0; ind < quarry.buildingContent.length ; ind++)
			{
				
				var rock:QuarryStone = quarry.buildingContent[ind];
				
				if(rock.level < GameData.STONE_RESPAWN_TIME)
				{
					// do nothing				
				}
				
				else if(rock.beingWorked) // rock being worked
				{
					// do nothing
				}
				else if(rock.worker) // rock has a worker (but not being worked)
				{
					if(rock.worker.col == cache_col && rock.worker.row == cache_row && rock.worker.isIdle()) // the minion is ready in the rockfield location
					{
						rock.startWork();
					}
					else if(!rock.worker.targetPosition) // the minion isn't on the way (and not in the quarry location)
					{
						if(rock.worker.ghostMode) // already assigned to this building probably
						{
							rock.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else if (rock.worker.col == rally_col && rock.worker.row == rally_row) // just got to the rally point after being attached to this rockfield
						{
							rock.worker.ghostMode = true;
							rock.worker.targetPosition = {col: cache_col, row: cache_row};
						}
						else
						{
							rock.worker.targetPosition = {col: rally_col, row: rally_row};
						}
						
						rock.worker.update();
					}
				}
				else if(workers.length > 0) // we have some minions to work the field
				{
					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
					{
						var curr_minion:Minion = workers[minion_ind];
						if(curr_minion.isIdle()) // found an available worker
						{
							rock.worker = curr_minion;
							rock.parent_cutter = this;
							break;
						}
						
					}
				}
			}
		}
		
		
		
		public function stoneHarvested()
		{
			resource = resource + GameData.STONE_AMOUNT;
			gameScreen.pickupQuery(this)
		}
	}
}
