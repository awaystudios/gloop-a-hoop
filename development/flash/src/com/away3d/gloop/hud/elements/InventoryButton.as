package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.level.LevelInventoryItem;

	public class InventoryButton extends HUDElement
	{
		private var _item : LevelInventoryItem;
		
		public function InventoryButton(item : LevelInventoryItem)
		{
			super();
			
			_item = item;
			
			drawRect(0, 0, 50, 50, 0, 0, 0, 0);
			
			material = new ColorMaterial(0xffcc00);
		}
		
		
		public function get inventoryItem() : LevelInventoryItem
		{
			return _item;
		}
	}
}