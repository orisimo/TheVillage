﻿package com.thevillage {	import flash.display.MovieClip;	import flash.geom.Point;	import com.thevillage.GameData;	import com.thevillage.TileSprite;	import com.thevillage.TileTypes;	import com.thevillage.Minion;	import flash.utils.Timer;	import flash.events.TimerEvent;		public class Blacksmith extends Building	{				var metalShaft:MetalShaft;		var currShaft:MetalShaft;				public function Blacksmith (type:int, grid:Array, id:int, _gameScreen:GameScreen) 		{						super(type, grid, id, _gameScreen);							resType = TileTypes.RESOURCE_METAL;		}				override public function initBuilding()		{			super.initBuilding();						// init metalShafts			// initChair(1, 0);						// init resource			resource = 0;						// set rally point			rally_col = col + 0;			rally_row = row + 1;						cache_col = col + 0;			cache_row = row + 0;						resourceCap = GameData.BLACKSMITH_MAX_STORAGE;		}					override public function drawItem()		{			super.drawItem();						// rally point art			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable, true);			addChild(newSprite);						// first metalShaft						//trace(TileTypes.FISHING_CHAIR);			trace(gameScreen);			gameScreen.callAddItem(TileTypes.METAL_SHAFT, this);																		//e.target.dispatchEvent(new GameEvent(GameEvent.ADD_ITEM_EVENT, TileTypes.F, true));			/*			var chair_col:int = col+1;			var chair_row:int = row;						newSprite = new TileSprite(itemType, positionAvailable);			newSprite.x = GameData.TILE_SIZE;						addChild(newSprite);						*/															/*for(var ind:int = 0; ind < itemGrid.length ; ind++)			{				if(itemGrid[ind])				{					var chair_col:int = col + ind%Math.sqrt(itemGrid.length);					var chair_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));									metalShaft = new Crop(this, chair_col, chair_row);					buildingContent.push(metalShaft);				}			}*/		}				private function initShaft(add_col:int, add_row:int)		{						/*						var chair_col:int = col + add_col;			var chair_row = row + add_row;						metalShaft = new MetalShaft(this, chair_col, chair_row);			buildingContent.push(metalShaft);			*/				}								override public function update()		{			super.update();						for(var ind:int = 0; ind < buildingContent.length ; ind++)			{				var metalShaft:MetalShaft = buildingContent[ind];								if(metalShaft.level < 6) // metalShaft not ready				{					metalShaft.level++;				}				else if(metalShaft.beingWorked) // metalShaft being worked				{					// do nothing				}				else if(metalShaft.worker) // metalShaft has a worker (but not being woreked)				{					if(metalShaft.worker.col == rally_col && metalShaft.worker.row == rally_row && metalShaft.worker.isIdle()) // the minion is in the fisherman location					{						metalShaft.startWork();					}					else if(!metalShaft.worker.targetPosition) // the minion isn't on the way (and not in the fisherman location)					{						metalShaft.worker.targetPosition = {col: rally_col, row: rally_row};						metalShaft.worker.update();					}				}				else if(workers) // we have some minions to work the field				{					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers					{						var curr_minion:Minion = workers[minion_ind];						if(!curr_minion.isAssigned) // found an available worker						{							//trace("got a ready minion");							metalShaft.worker = curr_minion;							metalShaft.worker.isAssigned = true;							update();							break;						}											}				}			}		}				public function metalHarvested()		{			resource = resource + GameData.METAL_AMOUNT;			gameScreen.pickupQuery(this)		}	}}