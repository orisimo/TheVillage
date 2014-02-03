package com.thevillage 
{
	import com.thevillage.Building;
	import com.thevillage.TileSprite;
	import com.thevillage.GameEvent;
	
	import com.untoldentertainment.pathfinding.Pathfinder;
	import caurina.transitions.*;
	
	
	public class Minion extends Item
	{
		public var isMoving:Boolean;
		public var isIdle:Boolean;
		
		private var tileMap:TileMap;
		
		public var targetPosition:Object;
		public var distributionOrder:Object;
		public var buildingOrder:Building;
		
		public var handsContent:Object;
		public var readyToWork:Boolean;
		
		private var path:Array;
		
		private var gameScreen:GameScreen;
		
		public function Minion(type:int, grid:Array, id:int, _tileMap:TileMap, _gameScreen:GameScreen) 
		{
			isMoving = false;
			isIdle = true;
			tileMap = _tileMap;
			gameScreen = _gameScreen;
			super(type, grid, id);
			
			gameScreen.addEventListener(GameEvent.PLACE_ITEM_EVENT, updatePath);
		}
		
		private function updatePath(e:GameEvent)
		{
			if(targetPosition != null)
			{
				path = tileMap.getPathTo({col:col, row:row}, targetPosition);
			}
		}
		
		override public function update()
		{
			super.update();
			
			if(targetPosition)
			{
				// build a path
				if(!path)
				{
					path = tileMap.getPathTo({col:col, row:row}, targetPosition);
				}
				if(path[path.length-1].col == col && path[path.length-1].row == row) // arrived
				{
					targetPosition = null;
					isMoving = false;
					
					// set new random target
					gameScreen.setRandomDestination(this);
					updatePath(null);
					update();
				}
				else if(targetPosition != null) // has target position
				{
					isMoving = true;
					
					var travelTime:Number = TileTypes.getSpeedByType(itemType);
					
					//Tweener.addTween(this, {time: travelTime, x: path[1].col*GameData.TILE_SIZE, y: path[1].row*GameData.TILE_SIZE, transition: "linear", onComplete:update});
					animateMinion(travelTime, path[1].col*GameData.TILE_SIZE, path[1].row*GameData.TILE_SIZE, update);
					
					col = path[1].col;
					row = path[1].row;
				}
				path.shift();
			}
			else if(buildingOrder) // buildingOrder holds a Building object (the target building) and will give us access to some variables from the building
			{
				if(buildingOrder.allMaterialsComing) // all materials coming
				{
					if( buildingOrder.col == col && buildingOrder.row == row) // at building location
					{
						if(buildingOrder.allMaterialsReady) // all materials at location
						{
							// start building
						}
						else 
						{
							// wait for materialsReady (add listener?)
						}
					}
					else
					{
						// go to building
						targetPosition = {col: buildingOrder.col, row: buildingOrder.row};
						update();
					}
					
				}
				else // materials needed for construction
				{
					var materialsInStorage:Boolean = gameScreen.materialsQueue(buildingOrder, this); // this function checks if there are any materials still needed for this building in the storage, and if so reserves them with this minion's ID (the storage will transfer this to the minion when it arrives)
					if(materialsInStorage) 
					{
						// go to storage
						// AND tell building you will get these materials
						// AND reserve resources at storage
					}
					else
					{
						// go chop something
						// AND tell building you will get these materials
					}
				}
			}
			else if(distributionOrder) // Building object from which we need to pickup
			{
				if(handsContent)
				{
					if( gameScreen.storehouse.col == col && gameScreen.storehouse.row == row) // at storehouse
					{
						// put stuff in storehouse
						handsContent = null;
					}
					else
					{
						// go to storehouse
						targetPosition = {col:  gameScreen.storehouse.col, row:  gameScreen.storehouse.row};
						update();
					}
				}
				else
				{
					if( distributionOrder.col == col && distributionOrder.row == row) // at building location
					{
						// take merchandise from building
						//handsContent = something;
						// set destination to storehouse
						targetPosition = {col:  gameScreen.storehouse.col, row:  gameScreen.storehouse.row};
						update();
					}
					else
					{
						// set target position to building
						targetPosition = {col: distributionOrder.col, row: distributionOrder.row};
						update();
						// reserve the resources at the building
						distributionOrder.reserveResource(gameScreen.minionCapacity);
					}
				}
				
			}
		}
		
		public function animateMinion(travelTime:Number, targetX:Number, targetY: Number, onCompleteFunc:Function = null)
		{
			Tweener.addTween(this, {time: travelTime, x: path[1].col*GameData.TILE_SIZE, y: path[1].row*GameData.TILE_SIZE, transition: "linear", onComplete:update});
		}
	}
}
