package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.events.InventoryEvent;
	import com.away3d.gloop.level.LevelInventoryItem;

	public class InventoryButton extends HUDElement
	{
		private var _item : LevelInventoryItem;
		
		private var _enabledMat : ColorMaterial;
		private var _disabledMat : ColorMaterial;
		
		public function InventoryButton(item : LevelInventoryItem)
		{
			super();
			
			_item = item;
			_item.addEventListener(InventoryEvent.ITEM_CHANGE, onItemChange);
			
			drawRect(0, 0, 50, 50, 0, 0, 0, 0);
			
			_enabledMat = new ColorMaterial(0x00aa00);
			_disabledMat = new ColorMaterial(0xff0000);
			
			redraw();
		}
		
		
		public function get inventoryItem() : LevelInventoryItem
		{
			return _item;
		}
		
		
		private function redraw() : void
		{
			material = (_item.numLeft > 0)? _enabledMat : _disabledMat;
		}
		
		
		private function onItemChange(ev : InventoryEvent) : void
		{
			redraw();
		}
	}
}