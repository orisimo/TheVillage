package com.thevillage 
{
	import com.thevillage.Building;
	import com.thevillage.GameEvent;
	
	import com.untoldentertainment.pathfinding.Pathfinder;
	import caurina.transitions.*;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	
	public class Minion extends Item
	{
		private var tileMap:TileMap;
		
		public var targetPosition:Object;
		public var distributionOrder:Building;
		public var buildingOrder:Building;
		
		public var handsContent:Array;
		public var isWorking:Boolean;
		public var isMoving:Boolean;
		public var isAssigned:Boolean;
		
		private var path:Array;
		
		private var gameScreen:GameScreen;
		
		public var onCompleteFunc:Function;
		public var ghostMode:Boolean = false;
		
		public var parent_object:MovieClip;
		
		public function Minion(type:int, grid:Array, id:int, _tileMap:TileMap, _gameScreen:GameScreen) 
		{
			isMoving = false;
			isWorking = false;
			isAssigned = false;
			
			tileMap = _tileMap;
			gameScreen = _gameScreen;
			super(type, grid, id);
			
			gameScreen.addEventListener(GameEvent.PLACE_ITEM_EVENT, updatePath);
		}
		
		public function isIdle():Boolean
		{
			return(Boolean(!isWorking && !isMoving && !distributionOrder && !buildingOrder));
		}
		
		public function initMinion()
		{
			//trace("init building");
			addEventListener(MouseEvent.CLICK, onMinionClick);
		}
		
		private function onMinionClick(e:MouseEvent)
		{
			gameScreen.minionClick(this);
		}
		
		private function updatePath(e:GameEvent)
		{
			if(targetPosition != null)
			{
				path = tileMap.getPathTo({col:col, row:row}, targetPosition, ghostMode);
			}
		}
		
		override public function update()
		{
			super.update();
			
			//trace("minion update");
			//trace("targetPosition: "+targetPosition);
			
			if(targetPosition)
			{
				// build a path
				if(!path)
				{
					path = tileMap.getPathTo({col:col, row:row}, targetPosition, ghostMode);
				}
				/*if(handsContent)
				{
					trace("targetPosition: "+targetPosition.col,targetPosition.row);
					trace("path:" +path);
					trace("location: "+col, row);
					trace("path[0]: "+path[0].col, path[0].row);
					trace("path test: "+tileMap.getPathTo({col:col, row:row}, targetPosition));
				}*/
				if(path==null)
				{
					trace("path from "+String(col)+" "+ String(row) +" to "+String(targetPosition.col)+" "+ String(targetPosition.row)+" is blocked");
				}
				else if(path.length <= 1) // arrived
				{
					trace("arrived")
					targetPosition = null;
					path = null;
					isMoving = false;
					update();
					// set new random target
					//gameScreen.setRandomDestination(this);
					//updatePath(null);
					//update();
				}
				else if(targetPosition != null) // has target position
				{
					isMoving = true;
					
					var travelTime:Number = TileTypes.getSpeedByType(itemType);
					
					//Tweener.addTween(this, {time: travelTime, x: path[1].col*GameData.TILE_SIZE, y: path[1].row*GameData.TILE_SIZE, transition: "linear", onComplete:update});
					// path.length ==2 --> last movement
					animateMinion(travelTime, path[1].col*GameData.TILE_SIZE, path[1].row*GameData.TILE_SIZE, Boolean(path.length == 2));
					
					col = path[1].col;
					row = path[1].row;
				}
				if(path != null)
				{
					path.shift();
				}
			}
			else if(buildingOrder) // buildingOrder holds a Building object (the target building) and will give us access to some variables from the building
			{
				trace("minion building order")
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
					for(var conInd:int; conInd < buildingOrder.constructionMat.length; conInd++)
					{
						if(buildingOrder.constructionMat[conInd]>0)
						{
							if(gameScreen.storageManager.resourceQuery(int(5+conInd),GameData.MAX_HAND_CONTENT,this))
							{
								buildingOrder.constructionMat[conInd] -= GameData.MAX_HAND_CONTENT;
								targetPosition = {col:  gameScreen.storehouse.rally_col, row:  gameScreen.storehouse.rally_row};
								update();
							}
							else
							{
								switch(conInd)
								{
									case 0: //wood
										break;
									case 1: //stone
										break;
									case 2: //metal
										break;
									default :
										break;
								}
							}
						}
					}
				}
			}
			else if(distributionOrder) // Building object from which we need to pickup
			{
				trace("distribution order exists");
				if(handsContent)
				{
					trace("hands full");
					if( gameScreen.storehouse.rally_col == col && gameScreen.storehouse.rally_row == row) // at storehouse
					{
						// put stuff in storehouse
						trace("pushing resources");
						gameScreen.storageManager.resourcePush(handsContent[0], handsContent[1]);
						handsContent = null;
						distributionOrder = null;
					}
					else
					{
						// go to storehouse
						trace("storehouse: "+gameScreen.storehouse);
						trace("storehouse position: "+gameScreen.storehouse.rally_col, gameScreen.storehouse.rally_row);
						targetPosition = {col:  gameScreen.storehouse.rally_col, row:  gameScreen.storehouse.rally_row};
						update();
					}
				}
				else
				{
					trace("hands empty");
					if( distributionOrder.rally_col == col && distributionOrder.rally_row == row) // at building location
					{
						trace("arrived at pickup location");
						// take merchandise from building
						handsContent = [Math.min(distributionOrder.resource, GameData.MAX_HAND_CONTENT), distributionOrder.resType];
						distributionOrder.resource = Math.max(0, distributionOrder.resource - GameData.MAX_HAND_CONTENT);
						
						// set destination to storehouse
						trace("changing targetPosition to - col: "+gameScreen.storehouse.rally_col +" row: "+gameScreen.storehouse.rally_row);
						targetPosition = {col:  gameScreen.storehouse.rally_col, row:  gameScreen.storehouse.rally_row};
						update();
					}
					else
					{
						trace("away from pickup location. heading there now");
						// set target position to building
						targetPosition = {col: distributionOrder.rally_col, row: distributionOrder.rally_row};
						update();
					}
				}
				
			}
		}
		
		public function animateMinion(travelTime:Number, targetX:Number, targetY: Number, lastMovement:Boolean = false)
		{
			//trace("animate minion");
			//trace("targetX: "+targetX, "targetY: "+targetY);
			//trace("target position: "+targetPosition.col, targetPosition.row);
			var myOnCompleteFunc:Function;
			if(onCompleteFunc!=null && lastMovement)
			{
				myOnCompleteFunc = onCompleteFunc;
				onCompleteFunc = null;
			}
			else
			{
				myOnCompleteFunc = update;
			}
			Tweener.addTween(this, {time: travelTime, x: targetX, y: targetY, transition: "linear", onComplete:myOnCompleteFunc});
		}
		
		override public function drawItem()
		{
			var newSprite:TileSprite;
			
			newSprite = new TileSprite(itemType, positionAvailable);
			
			addChild(newSprite);
		}
	}
}
