package com.thevillage 
{
public class StorageManager
{
	var resources:Object;
	var maxResources:int;
	
	public function StorageManager() 
	{
		initResources();
	}
	
	public function initResources()
	{
		resources.crops = 0;
		resources.cheese = 0;
		resources.fish = 0;
		resources.meat = 0;
	}
	
	public function resourcePush(resType:int, resAmount:int)
	{
		var totalResources:int = 0;
		for each(var amt in resources)
		{
			totalResources += amt;
		}
		
		if(totalResources + resAmount > maxResources)
		{
			// not enough space - wait outside
		}
		else
		{
			// put the resources here and go back to being idle
		}
	}
	
	public function resourceQuery(resType:int, resAmount:int)
	{
		var storedAmount:int;
		switch(resType)
		{
			case TileTypes.RESOURCE_WHEAT:
				storedAmount = resources.wheat;
				break;
			case TileTypes.RESOURCE_CHEESE:
				storedAmount = resources.cheese;
				break;
			case TileTypes.RESOURCE_FISH:
				storedAmount = resources.fish;
				break;
			case TileTypes.RESOURCE_MEAT:
				storedAmount = resources.meat;
				break;
			case TileTypes.RESOURCE_WOOD:
				storedAmount = resources.meat;
				break;
			case TileTypes.RESOURCE_STONE:
				storedAmount = resources.meat;
				break;
			case TileTypes.RESOURCE_MEAT:
				storedAmount = resources.meat;
				break;
			default:
				break;
		}
		
		if(storedAmount >= resAmount)
		{
			// set the resources aside in an array with building location ready for pickup
			// function returns 0 (no missing resources)
		}
		else if(storedAmount > 0)
		{
			// set the resources aside in an array with building location ready for pickup
			// function returns amount of missing resources
		}
		else
		{
			// tell the building we don't have this resource
			// function returns amount of missing resources
		}
	}