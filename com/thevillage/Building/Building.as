﻿package com.thevillage.Building
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.thevillage.GameData;
	import com.thevillage.GameScreen;
	import com.thevillage.TileSprite;
	import com.thevillage.TileTypes;
	import com.thevillage.Minion;
	import com.thevillage.Item;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	
	
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
		
		public var isPlaced:Boolean = false;
		public var constructionQuota:Array;
		public var constructionMat:Array;
		public var allMaterialsComing:Boolean = true;
		public var allMaterialsReady:Boolean = true;
		public var underConstruction:Boolean = false;
		
		public var constructionTimer:Timer;
		private var constructionUnitsLeft:int;
		
		public var rally_col:int;
		public var rally_row:int;
		
		public var cache_col:int;
		public var cache_row:int;
		
		public var resource:int;
		public var resType:int;
		public var resourceCap:int;
		public var workersCap:int;
		
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
			workersCap = TileTypes.getWorkerCapByType(itemType);
			buildingContent = [];
		}
		
		public function timerUpdate(e:TimerEvent)
		{
			update();
		}
		
		public function initBuilding()
		{
			//trace("init building");
			underConstruction = false;
			drawItem();
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
			while(workers.length > workersCap)
			{
				workers[0].isWorking = false;
				workers[0].buildingOrder = null;
				workers.shift();
			}
			for(var ind:int = 0; ind < workersCap; ind++)
			{
				workers[ind].isWorking = false;
				workers[ind].buildingOrder = null;
				workers[ind].isAssigned = true;
			}
			trace("workers: "+workers);
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
		
		override public function drawItem()
		{
			super.drawItem();
			// isPlaced should be used to indicate ghost mode
			if(underConstruction)
			{
				for(var i:int = 0; i<itemGrid.length; i++)
				{
					if(itemGrid[i] == 0)
						continue;
					var constructionArt:TileSprite = new TileSprite(TileTypes.CONSTRUCTION_SITE, 0);
					constructionArt.x = i%Math.sqrt(itemGrid.length)*GameData.TILE_SIZE;
					constructionArt.y =  Math.floor(i/Math.sqrt(itemGrid.length))*GameData.TILE_SIZE;
					addChild(constructionArt);
					spriteArray.push(constructionArt);
				}
			}
			else
			{
				rallyArt = new TileSprite(itemType, 0); // isPlaced should be used to indicate ghost mode
				addChild(rallyArt);
				spriteArray.push(rallyArt);
			}
			if(!positionAvailable)
			{
				// color art red
			}
			
			/*for(var ind:int = 0; ind < itemGrid.length ; ind++)
			{
				if(itemGrid[ind])
				{
					var pen_col:int = col + ind%Math.sqrt(itemGrid.length);
					var pen_row = row + Math.floor(ind/Math.sqrt(itemGrid.length));
				
					pen = new Pen(this, pen_col, pen_row);
					buildingContent.push(pen);
				}
			}*/
		}
		
		public function constructionMaterialsSupply(handsContent:Array)
		{
			trace("construction materials supply: before - "+constructionMat+" supplying: "+handsContent);
			constructionMat[handsContent[0]-5] += handsContent[1];
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