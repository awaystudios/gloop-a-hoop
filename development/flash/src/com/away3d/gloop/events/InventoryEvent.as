package com.away3d.gloop.events
{
	import com.away3d.gloop.level.LevelInventoryItem;
	
	import flash.events.Event;
	
	public class InventoryEvent extends Event
	{
		private var _item : LevelInventoryItem;
		
		public static const ITEM_SELECT : String = 'itemSelect';
		public static const ITEM_CHANGE : String = 'itemReturn';
		
		public function InventoryEvent(type:String, item : LevelInventoryItem = null)
		{
			super(type);
			
			_item = item;
		}
		
		
		public function get item() : LevelInventoryItem
		{
			return _item;
		}
		
		
		public override function clone() : Event
		{
			return new InventoryEvent(type, item);
		}
	}
}