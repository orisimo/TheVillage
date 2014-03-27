﻿package com.thevillage {	import flash.display.MovieClip;	import flash.geom.Point;	import com.thevillage.GameData;	import com.thevillage.TileSprite;	import com.thevillage.TileTypes;	import com.thevillage.Minion;	import flash.utils.Timer;	import flash.events.TimerEvent;		public class Lumbermill extends Building	{				var crop:Crop;		var currCrop:Crop;		var forest:Forest;				public function Lumbermill(type:int, grid:Array, id:int, _gameScreen:GameScreen, _forest:Forest) 		{			super(type, grid, id, _gameScreen);			resType = TileTypes.RESOURCE_WOOD;			forest = _forest;		}				override public function initBuilding()		{			super.initBuilding();						// init crops			//initCrop(1, 0);						// init resource			resource = 0;						// set rally point			rally_col = col + 0;			rally_row = row + 1;						cache_col = col + 0;			cache_row = row + 0;		}					override public function drawItem()		{			super.drawItem();						// rally point art			var newSprite:TileSprite = new TileSprite(itemType, positionAvailable, true);			addChild(newSprite);						// first crop			//var crop_col:int = col+1;			//var crop_row:int = row;						/*						newSprite = new TileSprite(itemType, positionAvailable);			newSprite.x = GameData.TILE_SIZE;						addChild(newSprite);						*/						/*for(var ind:int = 0; ind < itemGrid.length ; ind++)			{				if(itemGrid[ind])				{					var crop_col:int = col + ind%Math.sqrt(itemGrid.length);					var crop_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));									crop = new Crop(this, crop_col, crop_row);					buildingContent.push(crop);				}			}*/		}								override public function update()		{			super.update();						for(var ind:int = 0; ind < buildingContent.length ; ind++)			{				var crop:Crop = buildingContent[ind];								if(crop.level < 6) // crop not ready				{					crop.level++;				}				else if(crop.beingWorked) // crop being worked				{					// do nothing				}				else if(crop.worker) // crop has a worker (but not being woreked)				{					if(crop.worker.col == rally_col && crop.worker.row == rally_row && crop.worker.isIdle()) // the minion is in the cropfield location					{						crop.startWork();					}					else if(!crop.worker.targetPosition) // the minion isn't on the way (and not in the cropfield location)					{						crop.worker.targetPosition = {col: rally_col, row: rally_row};						crop.worker.update();					}				}				else if(workers) // we have some minions to work the field				{					for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers					{						var curr_minion:Minion = workers[minion_ind];						if(!curr_minion.isAssigned) // found an available worker						{							//trace("got a ready minion");							crop.worker = curr_minion;							crop.worker.isAssigned = true;							update();							break;						}											}				}			}		}				public function cropHarvested()		{			resource = resource + GameData.CROP_AMOUNT;			gameScreen.pickupQuery(this)		}	}}