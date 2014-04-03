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
	
	public class Hunter extends Building
	{
		
		var tree:ForestTree;
		var currTree:ForestTree;
		var wildlife:Wildlife;
		
		public var level:int;
		
		public var worker:Minion;
		
		public var parent_field:CropField;
		
		public var workTimer:Timer;
		
		public function Hunter(type:int, grid:Array, id:int, _gameScreen:GameScreen, _wildlife:Wildlife) 
		{
			super(type, grid, id, _gameScreen);
			
			level = 0;
			col = _col;
			row = _row;
			
			resType = TileTypes.RESOURCE_MEAT;
			wildlife = _wildlife;
		}
		
		override public function initBuilding()
		{
			super.initBuilding();
			
			// init trees
			//initCrop(1, 0);
			
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
		}
		
		
		override public function update()
		{
			super.update();
			
			for(var minion_ind:int = 0; minion_ind < workers.length; minion_ind++) // loop through the workers
			{
				var curr_minion:Minion = workers[minion_ind];
				if(curr_minion.isIdle()) // found an available worker
				{
					trace("assigning");
					startWork(curr_minion);
					break;
				}
			}
		}
		
		public function treeHarvested()
		{
			resource = resource + GameData.CROP_AMOUNT;
			gameScreen.pickupQuery(this)
		}
		
		public function startWork(worker:Minion)
		{
			worker.ghostMode = true;
			worker.targetPosition = {col: col, row: row};
			worker.parent_object = this;
			worker.onCompleteFunc = function() {this.parent_object.workTimer.start(); this.update();};
			worker.update();
			//trace("start work");
			
		}
		public function finishWork(e:TimerEvent)
		{
			trace("finish work (send to cache)");
			workTimer.reset();
			worker.targetPosition = {col: parent_field.cache_col, row: parent_field.cache_row};
			worker.onCompleteFunc = function(){parent_field.cropHarvested(); this.update();}
			worker.isWorking = false;
			worker.update();
			beingWorked = false;
		}
	}
}
