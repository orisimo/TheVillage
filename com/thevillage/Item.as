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
		
		public var spriteArray:Array;
		
		private var ind:int;
		
		private var itemTimer:Timer;
		
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
			clearArt();
		}
		
		public function clearArt()
		{
			for(ind=0;ind<spriteArray.length;ind++)
			{
				MovieClip(spriteArray[ind].parent).removeChild(MovieClip(spriteArray[ind]));
			}
			spriteArray = [];
		}
	}
}
