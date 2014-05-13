package com.thevillage 
{
	import com.thevillage.GameData;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	
	public class TileSprite extends MovieClip
	{
		public var art:MovieClip;
		public function TileSprite(itemType:int, tileOrientation:int = 0)
		{
			switch (itemType)
			{
				case TileTypes.MAP_TILE_BASIC:
					art = new ArtMapTileBasic() as MovieClip;
					break;
				case TileTypes.VILLAGER: // villager
					art = new ArtVillager() as MovieClip;
					break;
				case TileTypes.TREE: // tree
					art = new ArtTree() as MovieClip;
					break;
				case TileTypes.STONE: // stone
					art = new ArtStone() as MovieClip;
					break;
				case TileTypes.WALL: // Wall
					art = new ArtWallRally() as MovieClip;
					break;
				case TileTypes.BONFIRE: // Bonfire
					art = new ArtBonfireRally() as MovieClip;
					break;
				case TileTypes.MANOR_HOUSE: // Manor house
					art = new ArtManorRally() as MovieClip;
					break;
				case TileTypes.STOREHOUSE:
					art = new ArtStorageRally() as MovieClip;
					break;
				case TileTypes.CROP_FIELD:
					art = new ArtCropFieldRally() as MovieClip;
					break;
				case TileTypes.CROP:
					art = new ArtCropFieldContent() as MovieClip;
					break;
				case TileTypes.LUMBERMILL:
					art = new ArtLumbermillRally() as MovieClip;
					break;
				case TileTypes.HUNTER:
					art = new ArtHunterRally() as MovieClip;
					break;
				case TileTypes.STONECUTTER:
					art = new ArtStonecutterRally() as MovieClip;
					break;
				case TileTypes.PASTURE:
					art = new ArtPastureRally() as MovieClip;
					break;
				case TileTypes.PEN:
					art = new ArtPastureContent() as MovieClip;
					break;
				case TileTypes.FISHERMAN:
					art = new ArtFishermanRally() as MovieClip;
					break;
				case TileTypes.FISHING_CHAIR:
					art = new ArtFishermanContent() as MovieClip;
					break;
				case TileTypes.BLACKSMITH:
					art = new ArtBlacksmithRally() as MovieClip;
					break;
				case TileTypes.METAL_SHAFT:
					art = new ArtBlacksmithContent() as MovieClip;
					break;
				case TileTypes.CONSTRUCTION_SITE:
					art = new ConstructionSite() as MovieClip;				
					break;
				default:
					break;
				
			}
			
			addChild(MovieClip(art));
			
			if(tileOrientation != 0)
			{
				art.gotoAndStop(tileOrientation);
			}
			//graphics.beginFill(color, spriteAlpha);
			//graphics.drawRect(0, 0, GameData.TILE_SIZE, GameData.TILE_SIZE);
			//graphics.endFill();
		}
	}	
}
