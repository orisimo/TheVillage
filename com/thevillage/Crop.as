package com.thevillage 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	public class Crop extends MovieClip
	{
		public var level:int;
		public var row:int;
		public var col:int;
		
		public var beingWorked:Boolean;
		
		public var worker:Minion;
		
		public var parent_field:CropField;
		
		private var workTimer:Timer;
		
		public function Crop(field:CropField, _col:int, _row:int) 
		{
			level = 0;
			col = _col;
			row = _row;
			
			parent_field = field;
			
			workTimer = new Timer(TileTypes.getWorkTimeByType(parent_field.itemType), 1);
			addEventListener(TimerEvent.TIMER_COMPLETE, finishWork);
		}
		
		public function startWork(minion:Minion)
		{
			worker = minion;
			// get the minion to the crop tile (visual)
			worker.animateMinion(TileTypes.getSpeedByType(TileTypes.VILLAGER), col*GameData.TILE_SIZE, row*GameData.TILE_SIZE);
			
			worker.readyToWork = false;
			
			workTimer.start();
			
			beingWorked = true;
		}
		
		public function finishWork(e:TimerEvent)
		{
			worker.animateMinion(TileTypes.getSpeedByType(TileTypes.VILLAGER), parent_field.rally_col*GameData.TILE_SIZE, parent_field.rally_row*GameData.TILE_SIZE);
			worker.readyToWork = true;
			worker = null;
			
			parent_field.cropHarvested();
		}
	}
}


