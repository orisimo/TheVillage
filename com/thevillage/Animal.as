﻿package com.thevillage 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	import com.thevillage.*;
	import com.thevillage.Building.*;
	
	public class Animal extends MovieClip
	{
		public var level:int;
		public var row:int;
		public var col:int;
		
		public var beingWorked:Boolean;		
		public var worker:Minion;		
		public var parent_hunter:Hunter;
		public var wildlife:Wildlife;
		public var workTimer:Timer;
		public var art:TileSprite;
		
		
		
		public function Animal (_col:int, _row:int, wildlife:Wildlife) 
		{			
			
			level = GameData.ANIMAL_BIRTH_RATE;
			col = _col;
			row = _row;
			
			// rally point art
			art = new TileSprite(TileTypes.ANIMAL, 0);
			addChild(art);
			
			art.art.gotoAndStop(art.art.totalFrames);
			
			
			workTimer = new Timer(TileTypes.getWorkTimeByType(wildlife.itemType), 1);
			workTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishWork);
		}
		
		
		
		public function startWork()
		{
			//worker.ghostMode = true;
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
			workTimer.reset();
			worker.targetPosition = {col: parent_hunter.cache_col, row: parent_hunter.cache_row};
			worker.onCompleteFunc = function(){parent_hunter.animalHarvested(); this.update();}
			worker.update();
			level = 0;
			worker.isWorking = false;
			worker = null;
			beingWorked = false;
		}
	}
}


