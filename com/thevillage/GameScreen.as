﻿package com.thevillage
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	import com.thevillage.Building.*;
	
	public class GameScreen extends MovieClip
	{
		var dragTarget:Item;
		
		var dragItemPosition:Array
		public var itemsContainer:MovieClip;
		
		var currMinions:Array;
		var currBuildings:Array;
		
		var obstaclesContainer:MovieClip;
		
		var gridGraphics:MovieClip;
		
		var tileMap:TileMap;
		
		var currentMouseTile:Array;
		var currentPositionAvailable:Boolean;
		
		var currClickedMinion:Minion;
		
		var gameTimer:Timer;
		
		var ind:int;
		
		public var storehouse:Building;
		public var forest:Forest;
		public var wildlife:Wildlife;
		public var quarry:Quarry;
		public var mountain:Mountain;
		
		public var minionCapacity:int = 10;
		
		var keyboardController:KeyboardController;
		
		public var storageManager:StorageManager;
		
		var gameUI:GameUI;
		
		public function GameScreen(game_ui:GameUI) 
		{
			gameUI = game_ui;
			gameUI.gameScreen = this;
			
			if(stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
		
		public function addedToStage(e:Event)
		{
			init();
		}
		
		private function init()
		{
			tileMap = new TileMap();
			tileMap.createRandomMap();
			
			//tileMap.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -50, -50, -50, 0);
			addChild(tileMap);
			
			
			stage.addEventListener(GameEvent.ADD_ITEM_EVENT, addItemPlacer);
			//obstaclesContainer = new MovieClip();
			//drawObstacles();
			//addChild(obstaclesContainer);
			
			storageManager = new StorageManager(this);
			
			currMinions = [];
			currBuildings = [];
			
			itemsContainer = new MovieClip();
			//itemsContainer.transform.colorTransform = new ColorTransform(1, 1, 1, 1, -50, -50, -50, 0);
			addChild(itemsContainer);
			
			forest = new Forest(NaN,null,tileMap.getNewID(), this);
			forest.initBuilding();
			itemsContainer.addChild(forest);
			
			wildlife = new Wildlife(NaN,null,tileMap.getNewID(), this);
			wildlife.initBuilding();
			itemsContainer.addChild(wildlife);
			
			quarry = new Quarry(NaN,null,tileMap.getNewID(), this);
			quarry.initBuilding();
			itemsContainer.addChild(quarry);
			
			drawGrid();
			addChild(gridGraphics);
			
			initGameTimer();
			
			keyboardController = new KeyboardController(this);
			
			// make some starter items (temp)
			for(var num:int=0; num<0; num++)
			{
				//var tempType:int = Math.random() > 0.5 ? Math.ceil(Math.random()*16) : 101;
				var tempType:int = 101;
				var tempItem:Item = createItem(tempType, [Math.floor(Math.random()*GameData.GRID_WIDTH), Math.floor(Math.random()*GameData.GRID_HEIGHT)]);
				//trace("itemType: "+tempItem.itemType);
				if(tileMap.verifyPosition({row:tempItem.row, col:tempItem.col}, tempItem.itemGrid))
				{
					tempItem.positionAvailable = true;
					//setRandomDestination(tempItem);
					//trace("minion destination: "+Minion(tempItem).targetPosition.col, Minion(tempItem).targetPosition.row);
					placeItem(tempItem);
				}
				else
				{
					itemsContainer.removeChild(tempItem);
				}
				
			}
		}
		
		public function materialsQueue(targetBuilding:Building, targetMinion:Minion) : Boolean
		{
			return(true);
		}
		
		private function initGameTimer()
		{
			gameTimer = new Timer(GameData.TICK_TIME);
			gameTimer.addEventListener(TimerEvent.TIMER, onTick);
			gameTimer.start();
		}
		
		private function onTick(e:TimerEvent)
		{
			//trace("tick "+gameTimer.currentCount);
		}
		
		private function addItemPlacer(e:GameEvent)
		{
			itemPlacer(int(e.eventData), getMouseTile());
		}
		
		
		
		private function itemPlacer (itemType:int, position:Array, parent_building:Building = null): Item
		{
			dragTarget = createItem(itemType,position, parent_building);
			
			dragItem(new Event(MouseEvent.MOUSE_MOVE));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragItem);
			stage.addEventListener(MouseEvent.MOUSE_UP, onPlaceClick);			
			
			return dragTarget;
		}
		
		private function createItem(itemType:int, position:Array, parent_building:Building = null):Item
		{
			
			//trace("createItem");
			var myItem:Item;
			
			switch (itemType)
			{
				case TileTypes.VILLAGER: // villager
					myItem = new Minion(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), tileMap, this);
					break;
					
				case TileTypes.WALL:
					myItem = new Wall(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.BONFIRE:
					myItem = new Bonfire(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.CROP_FIELD:
					myItem = new CropField(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.LUMBERMILL:
					myItem = new Lumbermill(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this, forest);
					break;
					
				case TileTypes.STONECUTTER:
					myItem = new Stonecutter(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this, quarry);
					break;
										
				case TileTypes.PASTURE:
					myItem = new Pasture(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.FISHERMAN:
					myItem = new Fisherman(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.BLACKSMITH:
					myItem = new Blacksmith(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;		
					
				case TileTypes.MANOR_HOUSE:
					myItem = new ManorHouse(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.STOREHOUSE:
					myItem = new Storage(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this);
					break;
					
				case TileTypes.FISHING_CHAIR:
					myItem = new FishingChair(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this, parent_building);
					break;
					
				case TileTypes.METAL_SHAFT:
					myItem = new MetalShaft(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this, parent_building);
					break;		
				
				case TileTypes.HUNTER:
					myItem = new Hunter(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), this, wildlife);
					break;		
				
				default:
					break;
			}
			
			//trace("whatsmyItem"+ myItem);			
			var gridData:Object = processGrid(myItem);
			
			
			myItem.col = Math.min(position[0], GameData.GRID_WIDTH - gridData.itemDimensions[0]) - gridData.itemTopLeftCorner[0];
			myItem.row = Math.min(position[1], GameData.GRID_HEIGHT - gridData.itemDimensions[1]) - gridData.itemTopLeftCorner[1];
			myItem.x = myItem.col * GameData.TILE_SIZE;
			myItem.y = myItem.row * GameData.TILE_SIZE;
			
			itemsContainer.addChild(myItem);
			
			return(myItem);
		}
		
		private function dragItem(e:Event)
		{
			var mouseTile:Array = getMouseTile();
			
			var gridData:Object = processGrid(dragTarget);
			
			if (mouseTile != currentMouseTile)
			{
				currentMouseTile = mouseTile;
				dragTarget.col = Math.min(currentMouseTile[0], GameData.GRID_WIDTH - gridData.itemDimensions[0]) - gridData.itemTopLeftCorner[0];
				dragTarget.row = Math.min(currentMouseTile[1], GameData.GRID_HEIGHT - gridData.itemDimensions[1]) - gridData.itemTopLeftCorner[1];
				dragTarget.x = dragTarget.col * GameData.TILE_SIZE;
				dragTarget.y = dragTarget.row * GameData.TILE_SIZE;
				
				dragTarget.positionAvailable = tileMap.verifyPosition({row:dragTarget.row, col:dragTarget.col}, dragTarget.itemGrid);
				dragTarget.drawItem();
			}
		}
		
		public function getIdleMinion():Minion
		{
			for( var minionInd:int = 0; minionInd < currMinions.length; minionInd++)
			{
				if(currMinions[minionInd].isIdle() && !currMinions[minionInd].isAssigned)
				{
					return currMinions[minionInd];
				}
			}
			return null;
		}
		
		public function processGrid(item:Item):Object
		{
			
			//trace("processGrid");
			
			//trace("myitem"+item);
			// uses item grid, returns top left corner and dimensions
			var minCol:int = Math.sqrt(item.itemGrid.length);
			var maxCol:int = 0;
			var currCol:int;
			var minRow:int = Math.sqrt(item.itemGrid.length);
			var maxRow:int = 0;
			var currRow:int;
			
			for(ind = 0; ind<item.itemGrid.length; ind++)
			{
				if(item.itemGrid[ind] == 1)
				{
					currCol = ind % Math.sqrt(item.itemGrid.length);
					if( currCol < minCol )
					{
						minCol = currCol;
					}
					if( currCol > maxCol )
					{
						maxCol = currCol;
					}
					
					currRow = Math.floor(ind / Math.sqrt(item.itemGrid.length));
					if( currRow < minRow )
					{
						minRow = currRow;
					}
					if( currRow > maxRow )
					{
						maxRow = currRow;
					}
				}
			}
			
			return {itemTopLeftCorner: [minCol, minRow], itemDimensions: [maxCol-minCol+1, maxRow-minRow+1]};
		}
		
		private function onPlaceClick(e:MouseEvent)
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragItem);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onPlaceClick);
				
			placeItem(dragTarget);
		}
		
		private function placeItem(item:Item)
		{
			if(item.positionAvailable)
			{
				
				dragTarget = null;
				
				if(item.itemType == TileTypes.VILLAGER)
				{
					Minion(item).drawItem();
					Minion(item).update();
					itemsContainer.setChildIndex(Minion(item), itemsContainer.numChildren-1);
					currMinions.push(Minion(item));
					
					Minion(item).initMinion();
				}
				else // building
				{
					tileMap.setNode(item, false); // set node(s) to non-traversable
					Building(item).allMaterialsComing = false;
					Building(item).allMaterialsReady = false;
					Building(item).underConstruction = true;
					trace("set underConstruction: "+Building(item).underConstruction);
					itemsContainer.setChildIndex(Building(item), 0);
					
					currBuildings.push(Building(item));
					
					Building(item).cache_col += Building(item).col;
					Building(item).cache_row += Building(item).row;
					
					Building(item).rally_col += Building(item).col;
					Building(item).rally_row += Building(item).row;
					
					Building(item).isPlaced = true;
					
					Building(item).drawItem();
					
					var idleMinion:Minion = getIdleMinion();
					if(idleMinion != null)
					{
						idleMinion.buildingOrder = Building(item);
						idleMinion.update();
					}
				}
				
				switch (item.itemType)
				{
					case TileTypes.WALL:
						break;
						
					case TileTypes.BONFIRE:
						break;
						
					case TileTypes.CROP_FIELD:
						break;
						
					case TileTypes.LUMBERMILL:
						break;
					
					case TileTypes.HUNTER:
						break;
						
					case TileTypes.STONECUTTER:
						break;
						
						
					case TileTypes.PASTURE:
						break;
						
					case TileTypes.FISHERMAN:
						var fishingChair:FishingChair = FishingChair(itemPlacer(17, getMouseTile() ,Building(item)));
						Building(item).buildingContent.push(fishingChair);
						
						break;
						
					case TileTypes.BLACKSMITH:
						var metalShaft:MetalShaft = MetalShaft(itemPlacer(TileTypes.METAL_SHAFT, getMouseTile() ,Building(item)));
						Building(item).buildingContent.push(metalShaft);
						
						break;
						
					case TileTypes.MANOR_HOUSE:
						break;
						
					case TileTypes.STOREHOUSE:
						storehouse = Building(item);
						break;
						
					default:
						break;
				}
				
				dispatchEvent(new GameEvent(GameEvent.PLACE_ITEM_EVENT, item.itemType, true));
			}
			else
			{
				trace("position unavailable");
			}
		}
		
		public function setRandomDestination(item:Item)
		{
			var positionAvailable:Boolean = false;
			var randPosition:Object = {};
			
			while(!positionAvailable)
			{
				randPosition.row = Math.floor(Math.random()*GameData.GRID_HEIGHT)
				randPosition.col = Math.floor(Math.random()*GameData.GRID_WIDTH);
				positionAvailable = tileMap.verifyPosition(randPosition, item.itemGrid);
			}
			Minion(item).targetPosition = randPosition;
			
		}
		
		private function destroyItem(item:Item)
		{
			item.parent.removeChild(item);
			tileMap.setNode(item, true); // set previous node to traversable
		}
		
		public function minionClick(clickedMinion:Minion)
		{
			currClickedMinion = clickedMinion;
			trace("minionClick");
		}
		
		public function buildingClick(clickedBuilding:Building)
		{
			trace("buildingClick");
			
			if(currClickedMinion && !currClickedMinion.isAssigned)
			{
				if(clickedBuilding.underConstruction)
				{
					currClickedMinion.buildingOrder = clickedBuilding;
				}
				else
				{
					clickedBuilding.workers.push(currClickedMinion);
					currClickedMinion.isAssigned = true;
				}
				currClickedMinion.update();
				currClickedMinion = null;
			}
		}
		
		private function getMouseTile():Array
		{
			return( [ Math.max(0, Math.min ( GameData.GRID_WIDTH - 1, Math.floor(mouseX/GameData.TILE_SIZE) ) ), Math.max(0, Math.min(GameData.GRID_HEIGHT-1, Math.floor(mouseY/GameData.TILE_SIZE) ) ) ] );
		}
		
		private function drawGrid()
		{
			gridGraphics = new MovieClip();
			
			gridGraphics.graphics.lineStyle(1, GameData.GRID_COLOR, GameData.GRID_ALPHA);
			
			for(var col:int = 0; col<=GameData.GRID_WIDTH;col++)
			{
				gridGraphics.graphics.moveTo(col*GameData.TILE_SIZE, 0);
				gridGraphics.graphics.lineTo(col*GameData.TILE_SIZE, GameData.GRID_HEIGHT*GameData.TILE_SIZE);
			}
			for(var row:int = 0; row<=GameData.GRID_HEIGHT;row++)
			{
				gridGraphics.graphics.moveTo(0, row*GameData.TILE_SIZE);
				gridGraphics.graphics.lineTo(GameData.GRID_WIDTH*GameData.TILE_SIZE, row*GameData.TILE_SIZE);
			}
		}
		
		public function zoomMap(zoomIn:Boolean)
		{
			scaleX = scaleY = scaleX + 0.05 * (zoomIn?1:-1);
		}
		
		public function moveMap(move_x:Number, move_y:Number)
		{
			x += move_x;
			y += move_y;
		}
		
		public function pickupQuery(building:Building)
		{
			var pickupMinion:Minion = getIdleMinion();
			if(!pickupMinion)
			{
				//trace("no idle minions");
				return;
			}
			//trace("pickup query. idle minion:" + pickupMinion)
			pickupMinion.distributionOrder = building;
			pickupMinion.update();
		}
		
		public function updateResources(resType:int, resAmount:int)
		{
			gameUI.updateResourcePanel(resType, resAmount);
		}
	}
	
}

