package com.thevillage {
	import flash.display.MovieClip;
	
	import com.thevillage.GameData;
	import com.thevillage.TileSprite;
	import flash.utils.Timer;
	
	public class Item extends MovieClip
	{
		
		public var itemType:int;
		// MANOR_HOUSE; CROP_FIELD; STOREHOUSE...
		
		public var itemID:int;
		// This holds the building ID as received from gamescreen via tilemap
		
		public var itemGrid:Array;
		// nXn array showing tiles occupied by building
		// e.g: [0, 1, 1, 0, 
		//		 1, 1, 1, 1, 
		//		 1, 1, 1, 1, 
		//		 0, 1, 1, 0]
		
		//public var itemPosition:Array;
		public var col:int;
		public var row:int;
		
		public var itemDimensions:Array;
		public var itemTopLeftCorner:Array;
		
		private var spriteArray:Array;
		// this is an array of the movieclips that compose the temp art
		
		private var ind:int;
		
		private var itemTimer:Timer;
		
		private var isPlaced:Boolean = false;
		public var positionAvailable:Boolean;
		
		public function Item(type:int, grid:Array, id:int) 
		{
			itemType = type;
			itemGrid = grid;
			itemID = id;
			spriteArray = [];
			
			drawItem();
		}
		
		public function update()
		{
			
		}
		
		public function drawItem()
		{
			for(ind = 0; ind<spriteArray.length; ind++)
			{
				removeChild(spriteArray[ind]);
			}
			spriteArray = [];
			// delete any previos art and clears the array;
			
			if(!isPlaced)
			{
				
			}
			
			for(ind = 0; ind<itemGrid.length; ind++)
			{
				var newSprite:TileSprite;
				
				if(itemGrid[ind] == 1)
				{
					if(positionAvailable)
					{
						newSprite = new TileSprite(TileTypes.colorByType(itemType));
					}
					else
					{
						newSprite = new TileSprite(0xFF0000);
					}
					
					newSprite.x = ind % Math.sqrt(itemGrid.length) * GameData.TILE_SIZE;
					newSprite.y = Math.floor(ind / Math.sqrt(itemGrid.length)) * GameData.TILE_SIZE;
					
					spriteArray.push(newSprite);
					
					addChild(newSprite);
				}
			}
		}
	}
}
