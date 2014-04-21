package com.thevillage 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	public class ForestTree extends MovieClip
	{
		public var level:int;
		public var row:int;
		public var col:int;
		
		public var beingWorked:Boolean;		
		public var worker:Minion;		
		public var parent_building:Building;
		public var forest:Forest;
		public var workTimer:Timer;
		public var art:TileSprite;
		
		
		
		public function ForestTree (_col:int, _row:int, forest:Forest) 
		{			
			
			level = GameData.TREE_RESPAWN_TIME;
			col = _col;
			row = _row;
			
			// rally point art
			art = new TileSprite(TileTypes.TREE, true, true);
			addChild(art);
			
			art.art.gotoAndStop(art.art.totalFrames);
			
			
			workTimer = new Timer(TileTypes.getWorkTimeByType(forest.itemType), 1);
			workTimer.addEventListener(TimerEvent.TIMER_COMPLETE, finishWork);
		}
		
		
		
		public function startWork()
		{
			//trace("start work (send to crop)");
			
			// get the minion to the crop tile
			//worker.ghostMode = true;
			worker.targetPosition = {col: col, row: row};
			worker.parent_object = this;
			worker.onCompleteFunc = function() {trace(this); this.parent_object.workTimer.start(); this.update();};
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
			worker.targetPosition = {col: parent_building.cache_col, row: parent_building.cache_row};
			trace("worker target pos: "+worker.targetPosition.col, worker.targetPosition.row);
			if(parent_building.itemType == TileTypes.LUMBERMILL && !parent_building.underConstruction)
			{
				worker.onCompleteFunc = function(){Lumbermill(parent_building).treeHarvested(); this.isMoving = false; this.update();}
			}
			else // probably construction materials
			{
				worker.handsContent = [0, GameData.MAX_HAND_CONTENT];
				worker.onCompleteFunc = function(){this.isMoving = false; this.update();}
			}
			worker.update();
			level = 0;
			worker.isWorking = false;
			worker = null;
			beingWorked = false;
		}
	}
}


