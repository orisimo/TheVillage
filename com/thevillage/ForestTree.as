﻿package com.thevillage {	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.display.MovieClip;		public class ForestTree extends MovieClip	{		public var level:int;		public var row:int;		public var col:int;				public var beingWorked:Boolean;				public var worker:Minion;				public var parent_mill:Lumbermill;				public var forest:Forest;				public var workTimer:Timer;				public function ForestTree (_col:int, _row:int, forest:Forest) 		{			level = 0;			col = _col;			row = _row;						// rally point art			var newSprite:TileSprite = new TileSprite(TileTypes.TREE, true, true);			addChild(newSprite);											workTimer = new Timer(TileTypes.getWorkTimeByType(forest.itemType), 1);			workTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishWork);		}				public function startWork()		{			//trace("start work (send to crop)");						// get the minion to the crop tile			//worker.animateMinion(TileTypes.getSpeedByType(TileTypes.VILLAGER), col*GameData.TILE_SIZE, row*GameData.TILE_SIZE);			worker.ghostMode = true;			worker.targetPosition = {col: col, row: row};			worker.parent_object = this;			worker.onCompleteFunc = function() {this.parent_object.workTimer.start(); this.update();};			worker.update();			//workTimer.start();			beingWorked = true;			//trace("start work");					}				public function finishWork(e:TimerEvent)		{			trace("finish work (send to cache)");			workTimer.reset();			worker.targetPosition = {col: parent_mill.cache_col, row: parent_mill.cache_row};			worker.onCompleteFunc = function(){parent_mill.treeHarvested(); this.update();}			worker.update();			level = 0;			worker.isWorking = false;			worker = null;			beingWorked = false;		}	}}