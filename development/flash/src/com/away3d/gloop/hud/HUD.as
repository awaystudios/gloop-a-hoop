package com.away3d.gloop.hud
{
	import away3d.events.MouseEvent3D;
	
	import com.away3d.gloop.events.GameEvent;
	import com.away3d.gloop.hud.elements.HUDElement;
	import com.away3d.gloop.hud.elements.InventoryButton;
	import com.away3d.gloop.hud.elements.StarIcon;
	import com.away3d.gloop.level.LevelInventoryItem;
	import com.away3d.gloop.level.LevelProxy;

	public class HUD extends HUDElement
	{
		private var _levelProxy : LevelProxy;
		
		private var _stars : Vector.<StarIcon>;
		
		private var _inventoryButtons : Vector.<InventoryButton>;
		
		public function HUD()
		{
			init();
		}
		
		
		private function init() : void
		{
			_stars = new Vector.<StarIcon>();
			_stars[0] = new StarIcon();
			_stars[0].y = 50;
			addChild(_stars[0]);
			
			_stars[1] = new StarIcon();
			_stars[1].x = 30;
			_stars[1].y = _stars[0].y;
			addChild(_stars[1]);
			
			_stars[2] = new StarIcon();
			_stars[2].x = 60;
			_stars[2].y = _stars[0].y;
			addChild(_stars[2]);
			
			_inventoryButtons = new Vector.<InventoryButton>();
		}
		
		
		public function reset(levelProxy : LevelProxy) : void
		{
			if (levelProxy != _levelProxy) {
				if (_levelProxy) {
					_levelProxy.removeEventListener(GameEvent.LEVEL_STAR_COLLECT, onLevelProxyStarCollect);
				}
				
				_levelProxy = levelProxy;
				_levelProxy.addEventListener(GameEvent.LEVEL_STAR_COLLECT, onLevelProxyStarCollect);
				
				clear();
				draw();
			}
			
			_stars[0].visible = false;
			_stars[1].visible = false;
			_stars[2].visible = false;
		}
		
		
		private function draw() : void
		{
			var i : uint;
			var len : uint;
			
			len = _levelProxy.inventory.items.length;
			for (i=0; i<len; i++) {
				var btn : InventoryButton;
				var item : LevelInventoryItem;
				
				item = _levelProxy.inventory.items[i];
				btn = new InventoryButton(item);
				btn.x = i*60;
				// TODO: try to avoid enabling the picking system for performance
				// TODO: picking system causes a runtime error on iPad2 ( pixel bender failure? )
				btn.mouseEnabled = true;
				btn.addEventListener(MouseEvent3D.CLICK, onInventoryButtonClick);
				
				addChild(btn);
				_inventoryButtons.push(btn);
			}
		}
		
		
		private function clear() : void
		{
			var btn : InventoryButton;
			
			while (btn = _inventoryButtons.pop()) {
				btn.removeEventListener(MouseEvent3D.CLICK, onInventoryButtonClick);
				removeChild(btn);
			}
		}
		
		
		private function onInventoryButtonClick(ev : MouseEvent3D) : void
		{
			var btn : InventoryButton;
			
			btn = InventoryButton(ev.currentTarget);
			
			_levelProxy.inventory.select(btn.inventoryItem);
		}
		
		
		private function onLevelProxyStarCollect(ev : GameEvent) : void
		{
			var i : uint;
			var len : uint;
			
			len = _levelProxy.starsCollected;
			
			for (i=0; i<len; i++) {
				_stars[i].visible = true;
			}
		}
	}
}