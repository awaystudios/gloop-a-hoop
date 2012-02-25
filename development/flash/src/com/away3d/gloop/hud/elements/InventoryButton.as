package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.events.InventoryEvent;
	import com.away3d.gloop.level.LevelInventoryItem;

	public class InventoryButton extends HUDElement
	{
		private var _item : LevelInventoryItem;
		
		public function InventoryButton(item : LevelInventoryItem)
		{
			super();
			
			_item = item;
			_item.addEventListener(InventoryEvent.ITEM_CHANGE, onItemChange);
			
			drawRect(0, 0, 50, 50, 0, 0, 0, 0);
			
			material = new ColorMaterial(0xffcc00);
		}
		
		
		public function get inventoryItem() : LevelInventoryItem
		{
			return _item;
		}
		
		
		private function onItemChange(ev : InventoryEvent) : void
		{
			visible = (_item.numLeft > 0);
		}
	}
}