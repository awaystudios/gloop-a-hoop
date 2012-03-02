package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.events.InventoryEvent;
	import com.away3d.gloop.level.LevelInventoryItem;
	
	import flash.display.Sprite;

	public class InventoryItemButton extends Sprite
	{
		private var _item : LevelInventoryItem;
		
		public function InventoryItemButton(item : LevelInventoryItem)
		{
			super();
			
			_item = item;
			_item.addEventListener(InventoryEvent.ITEM_CHANGE, onItemChange);
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, 50, 50);
		}
		
		
		public function get inventoryItem() : LevelInventoryItem
		{
			return _item;
		}
		
		
		private function onItemChange(ev : InventoryEvent) : void
		{
			// TODO: visual cue
		}
	}
}