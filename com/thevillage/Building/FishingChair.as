﻿package com.thevillage.Building
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	import com.thevillage.*;
	
	public class FishingChair extends Building
	{
		public var level:int;
		//public var row:int;
		//public var col:int;
		
		public var beingWorked:Boolean;
		
		public var worker:Minion;
		
		public var parent_fisherman:Fisherman;
		
		public var workTimer:Timer;
		
		public function FishingChair (type:int, grid:Array, id:int, _gameScreen:GameScreen, parent_building:Building) 
		{
			
			super(type, grid, id, _gameScreen);  
				  
			level = 0;
			//col = _col; 
			//row = _row;
			
			parent_fisherman = Fisherman(parent_building);
			workTimer = new Timer(TileTypes.getWorkTimeByType(parent_fisherman.itemType), 1);
			workTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishWork);
		}
		
		public function startWork()
		{
			//trace("start work (send to crop)");
			
			// get the minion to the crop tile
			//worker.animateMinion(TileTypes.getSpeedByType(TileTypes.VILLAGER), col*GameData.TILE_SIZE, row*GameData.TILE_SIZE);
			//worker.ghostMode = true;
			//worker.targetPosition = {col: col, row: row};
			workTimer.start();
			//workTimer.start();
			beingWorked = true;
			//trace("start work");
			
		}
		
		public function finishWork(e:TimerEvent)
		{
			trace("finish work (send to cache)");
			workTimer.reset();
			worker.targetPosition = {col: parent_fisherman.cache_col, row: parent_fisherman.cache_row};
			worker.onCompleteFunc = function(){parent_fisherman.fishHarvested(); this.update();}
			worker.update();
			level = 0;
			beingWorked = false;
		}
		
		public function fireMinion()
		{
			worker.onCompleteFunc = function(){this.ghostMode = false;};
			worker.isAssigned = false;
			beingWorked = false;
		}
	}
}


