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
	import flash.events.MouseEvent;
	
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
		
		public var rallyArt:TileSprite;
		
		public var allMaterialsComing:Boolean = true;
		public var allMaterialsReady:Boolean = true;
		public var underConstruction:Boolean;
		
		public var rally_col:int;
		public var rally_row:int;
		
		public var cache_col:int;
		public var cache_row:int;
		
		public var resource:int;
		public var resType:int;
		public var resourceCap:int;
		
		public var gameScreen:GameScreen;
		
		public function Building(type:int, grid:Array, id:int, _gameScreen:GameScreen) 
		{
			gameScreen = _gameScreen;
			
			super(type, grid, id);
			
			trace("building" + this);
			
			buildingTimer = new Timer(GameData.BUILDING_TICK);
			buildingTimer.addEventListener(TimerEvent.TIMER, timerUpdate);
			
			
			trace(gameScreen);
			
			workers = [];
			buildingContent = [];
		}
		
		public function timerUpdate(e:TimerEvent)
		{
			update();
		}
		
		public function initBuilding()
		{
			//trace("init building");
			buildingTimer.start();
			
			addEventListener(MouseEvent.CLICK, onBuildingClick)
		}
		
		private function onBuildingClick(e:MouseEvent)
		{
			gameScreen.buildingClick(this);
		}
		
		override public function update()
		{
			//trace("building update");
			super.update();
		}
		
		public function changeResourceAmount(delta_res:int)
		{
			resource += delta_res;
			rallyArt.art.gotoAndStop(Math.ceil(resource/resourceCap*rallyArt.art.totalFrames));
		}
	}
}