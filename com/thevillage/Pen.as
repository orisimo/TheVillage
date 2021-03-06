﻿package com.thevillage 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	import com.thevillage.*;
	import com.thevillage.Building.*;
	
	public class Pen extends MovieClip
	{
		public var level:int;
		public var row:int;
		public var col:int;
		
		public var beingWorked:Boolean;
		
		public var worker:Minion;
		
		public var parent_pasture:Pasture;
		
		private var workTimer:Timer;
		
		public function Pen(pasture:Pasture, _col:int, _row:int) 
		{
			level = 0;
			col = _col;
			row = _row;
			
			parent_pasture = pasture;
			
			workTimer = new Timer(TileTypes.getWorkTimeByType(parent_pasture.itemType), 1);
			workTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishWork);
		}
		
		public function startWork()
		{
			//trace("start work (send to crop)");
			
			// get the minion to the crop tile
			//worker.animateMinion(TileTypes.getSpeedByType(TileTypes.VILLAGER), col*GameData.TILE_SIZE, row*GameData.TILE_SIZE);
			worker.ghostMode = true;
			worker.targetPosition = {col: col, row: row};
			worker.parent_object = this;
			worker.onCompleteFunc = function() {this.parent_object.workTimer.start(); this.update();};
			worker.update();
			//workTimer.start();
			beingWorked = true;
			//trace("start work");
			
		}
		
		public function finishWork(e:TimerEvent)
		{
			trace("finish work (send to cache)");
			workTimer.reset();
			worker.targetPosition = {col: parent_pasture.cache_col, row: parent_pasture.cache_row};
			worker.onCompleteFunc = function(){parent_pasture.penHarvested(); this.update();}
			worker.update();
			level = 0;
			worker.isWorking = false;
			worker = null;
			beingWorked = false;
		}
	}
}


