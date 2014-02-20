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
	
	public class Building extends Item
	{
		public var buildingTimer:Timer;
		
		public var wood:int = 0;
		public var stone:int = 0;
		public var metal:int = 0;
		public var wheat:int = 0;
		public var cheese:int = 0;
		public var fish:int = 0;
		public var meat:int = 0;
		
		public var workers:Array;
		public var buildingContent:Array;
		
		public var crop:Crop;
		
		public var allMaterialsComing:Boolean = true;
		public var allMaterialsReady:Boolean = true;
		public var underConstruction:Boolean;
		
		public var rally_col:int;
		public var rally_row:int;
		
		public var resource:int;
		
		public function Building(type:int, grid:Array, id:int) 
		{
			super(type, grid, id);
			
			drawItem();
			
			buildingTimer = new Timer(GameData.BUILDING_TICK);
			buildingTimer.addEventListener(TimerEvent.TIMER, timerUpdate);
			
			workers = [];
		}
		
		public function timerUpdate(e:TimerEvent)
		{
			update();
		}
		
		public function initBuilding()
		{
			trace("init building");
			buildingTimer.start();
			buildingContent = [];
		}
		
		override public function update()
		{
			trace("building update");
			super.update();
		}
		
		public function changeResourceAmount(delta_res:int)
		{
			resource += delta_res;
		}
	}
}
