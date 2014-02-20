package com.thevillage
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.thevillage.GameEvent;
	import com.thevillage.Building;
	
	public class GameScreen extends MovieClip
	{
		var dragTarget:Item;
		
		var dragItemPosition:Array
		var itemsContainer:MovieClip;
		
		var obstaclesContainer:MovieClip;
		
		var gridGraphics:MovieClip;
		
		var tileMap:TileMap;
		
		var currentMouseTile:Array;
		var currentPositionAvailable:Boolean;
		
		var gameTimer:Timer;
		
		var ind:int;
		
		public var storehouse:Building;
		
		public var minionCapacity:int = 10;
		
		public function GameScreen() 
		{
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
			
			addChild(tileMap);
			
			stage.addEventListener(GameEvent.ADD_ITEM_EVENT, addItemPlacer);
			//obstaclesContainer = new MovieClip();
			//drawObstacles();
			//addChild(obstaclesContainer);
			
			itemsContainer = new MovieClip();
			addChild(itemsContainer);
			
			drawGrid();
			addChild(gridGraphics);
			
			initGameTimer();
			
			// make some starter items (temp)
			for(var num:int=0; num<8; num++)
			{
				//var tempType:int = Math.random() > 0.5 ? Math.ceil(Math.random()*16) : 101;
				var tempType:int = 101;
				var tempItem:Item = createItem(tempType, [Math.floor(Math.random()*GameData.GRID_WIDTH), Math.floor(Math.random()*GameData.GRID_HEIGHT)]);
				//trace("itemType: "+tempItem.itemType);
				if(tileMap.verifyPosition({row:tempItem.row, col:tempItem.col}, tempItem.itemGrid))
				{
					tempItem.positionAvailable = true;
					tempItem.update();
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
			dragTarget = createItem(int(e.eventData), getMouseTile());
			
			dragItem(new Event(MouseEvent.MOUSE_MOVE));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragItem);
			stage.addEventListener(MouseEvent.MOUSE_UP, onPlaceClick);
		}
		
		private function createItem(itemType:int, position:Array):Item
		{
			var myItem:Item;
			
			switch (itemType)
			{
				case TileTypes.VILLAGER: // villager
					myItem = new Minion(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID(), tileMap, this);
					break;
				case TileTypes.CROP_FIELD:
					myItem = new CropField(itemType, TileTypes.getItemGridByType(itemType), tileMap.getNewID());
					break;
				default:
					break;
			}
			
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
			var currItem:Item;
			for( var itemInd:int = 0; itemInd < itemsContainer.numChildren; itemInd++)
			{
				currItem = Item(itemsContainer.getChildAt(itemInd));
				if(currItem.itemType == TileTypes.VILLAGER)
				{
					if(Minion(currItem).isIdle)
					{
						return Minion(currItem);
					}
				}
			}
			return null;
		}
		
		public function processGrid(item:Item):Object
		{
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
				switch (item.itemType)
				{
					case TileTypes.VILLAGER: // villager
						setRandomDestination(Minion(item));
						Minion(item).drawItem();
						break;
					case TileTypes.CROP_FIELD:
						tileMap.setNode(item, false); // set node(s) to non-traversable
						Building(item).allMaterialsComing = false;
						Building(item).allMaterialsReady = false;
						Building(item).underConstruction = true;
						
						Building(item).workers.push(getIdleMinion());
						
						Building(item).initBuilding();
						break;
					default:
						break;
				}
				
				dispatchEvent(new GameEvent(GameEvent.PLACE_ITEM_EVENT, item.itemType, true));
				
				dragTarget = null;
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
		
		private function drawObstacles()
		{
			for(var col:int = 0; col< GameData.GRID_WIDTH; col++)
			{
				for(var row:int = 0; row< GameData.GRID_WIDTH; row++)
				{
					if(tileMap.map[col+row*GameData.GRID_WIDTH] == 1)
					{
						var obstacle:TileSprite = new TileSprite(0x333333);
						obstacle.x = col*GameData.TILE_SIZE;
						obstacle.y = row*GameData.TILE_SIZE;
						
						obstaclesContainer.addChild(obstacle);
					}
				}
			}
		}
	}
	
}
