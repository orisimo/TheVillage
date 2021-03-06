﻿package com.thevillage 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import com.thevillage.Building.*;
	
	public class QuarryStone extends MovieClip
	{
		public var level:int;
		public var row:int;
		public var col:int;
		
		public var beingWorked:Boolean;		
		public var worker:Minion;		
		public var quarry:Quarry;
		public var workTimer:Timer;
		public var art:TileSprite;
		
		public var parent_building:Building;
		
		public function QuarryStone (_col:int, _row:int, quarry:Quarry) 
		{			
			
			level = GameData.STONE_RESPAWN_TIME;
			col = _col;
			row = _row;
			
			// rally point art
			art = new TileSprite(TileTypes.STONE, 0);
			addChild(art);
			
			art.art.gotoAndStop(art.art.totalFrames);
			
			
			workTimer = new Timer(TileTypes.getWorkTimeByType(quarry.itemType), 1);
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
			worker.isWorking = true;
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
			if(!parent_building)
			{
				parent_building = worker.buildingOrder;
			}
			
			worker.isMoving = false;
			
			if(parent_building.itemType == TileTypes.STONECUTTER && !parent_building.underConstruction)
			{
				worker.targetPosition = {col: parent_building.cache_col, row: parent_building.cache_row};
				worker.onCompleteFunc = function(){Stonecutter(parent_building).stoneHarvested(); this.isMoving = false; this.update();}
			}
			else // probably construction materials
			{
				worker.handsContent = [0, GameData.MAX_HAND_CONTENT];
				worker.onCompleteFunc = function(){this.isMoving = false; this.update();}
			}
			worker.update();
			level--;
			worker.isWorking = false;
			worker = null;
			beingWorked = false;
		}
	}
}


