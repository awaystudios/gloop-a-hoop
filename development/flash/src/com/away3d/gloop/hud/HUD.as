package com.away3d.gloop.hud
{
	import away3d.core.base.data.Vertex;
	
	import com.away3d.gloop.hud.elements.HUDElement;
	import com.away3d.gloop.hud.elements.InventoryButton;
	import com.away3d.gloop.level.LevelInventoryItem;
	import com.away3d.gloop.level.LevelProxy;

	public class HUD extends HUDElement
	{
		private var _levelProxy : LevelProxy;
		
		private var _inventoryButtons : Vector.<InventoryButton>;
		
		public function HUD()
		{
			_inventoryButtons = new Vector.<InventoryButton>();
		}
		
		
		public function reset(levelProxy : LevelProxy) : void
		{
			_levelProxy = levelProxy;
			
			clear();
			draw();
		}
		
		
		private function draw() : void
		{
			var i : uint;
			var len : uint;
			
			len = _levelProxy.inventory.length;
			for (i=0; i<len; i++) {
				var btn : InventoryButton;
				var item : LevelInventoryItem;
				
				item = _levelProxy.inventory[i];
				btn = new InventoryButton(item);
				btn.x = i*60;
				
				addChild(btn);
				_inventoryButtons.push(btn);
			}
		}
		
		
		private function clear() : void
		{
			var btn : InventoryButton;
			
			while (btn = _inventoryButtons.pop()) {
				removeChild(btn);
			}
		}
	}
}