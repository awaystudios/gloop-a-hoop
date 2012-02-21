package com.away3d.gloop.level
{
	public class LevelInventoryItem
	{
		public var type : String;
		public var variant : String;
		public var used : Boolean;
		
		public function LevelInventoryItem(type : String, variant : String)
		{
			type = type;
			variant = variant;
		}
	}
}