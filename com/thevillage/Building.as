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
		
		public var constructionQuota:Array;
		public var constructionMat:Array;
		public var allMaterialsComing:Boolean = true;
		public var allMaterialsReady:Boolean = true;
		public var underConstruction:Boolean;
		
		public var constructionTimer:Timer;
		private var constructionUnitsLeft:int;
		
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
			
			constructionQuota = TileTypes.getConstructionMaterials(itemType);
			constructionMat = [0,0,0];
			
			addEventListener(MouseEvent.CLICK, onBuildingClick)
			
			buildingTimer = new Timer(GameData.BUILDING_TICK);
			buildingTimer.addEventListener(TimerEvent.TIMER, timerUpdate);
			
			constructionTimer = new Timer(GameData.CONSTRUCTION_TICK)
			constructionTimer.addEventListener(TimerEvent.TIMER, constructionUpdate);
			
			constructionUnitsLeft = TileTypes.getConstUnitsByType(itemType);
			
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
		}
		
		public function constructionUpdate(e:TimerEvent)
		{
			for(var minInd:int = 0; minInd < workers.length; minInd++)
			{
				if(workers[minInd].isWorking)
				{
					constructionUnitsLeft--;
				}
				if(constructionUnitsLeft <= 0)
				{
					constructionTimer.reset();
					constructionComplete();
				}
			}
			trace("constructionUnitsLeft: "+constructionUnitsLeft)
		}
		
		public function constructionComplete()
		{
			for(var minInd:int = 0; minInd < workers.length; minInd++)
			{
				workers[minInd].isWorking = false;
				workers[minInd].buildingOrder = null;
			}
			workers = [workers[0]] // get rid of all workers except the first
			workers[0].isAssigned = true;
			initBuilding();
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
		
		public function pushMinion(minion:Minion)
		{
			var workerExists:Boolean = false;
			for(var minInd:int = 0; minInd < workers.length; minInd++)
			{
				if(workers[minInd] == minion)
				{
					workerExists = true;
					break;
				}
			}
			if(!workerExists)
			{
				workers.push(minion);
			}
		}
		
		public function changeResourceAmount(delta_res:int)
		{
			resource += delta_res;
			rallyArt.art.gotoAndStop(Math.ceil(resource/resourceCap*rallyArt.art.totalFrames));
		}
		
		public function constructionMaterialsSupply(handsContent:Array)
		{
			trace("construction materials supply");
			constructionMat[handsContent[0]] += handsContent[1];
			var targetMat:Array = TileTypes.getConstructionMaterials(itemType);
			//trace("constructionMat: "+constructionMat);
			//trace("targetConstructionMat: "+TileTypes.getConstructionMaterials(itemType));
			if(constructionMat[0] == targetMat[0] && constructionMat[1] == targetMat[1] && constructionMat[2] == targetMat[2])
			{
				trace("all materials ready, start construction");
				allMaterialsReady = true;
				// building ready for construction
				constructionTimer.start();
			}
		}
	}
}