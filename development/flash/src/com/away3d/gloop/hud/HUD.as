package com.away3d.gloop.hud
{
	import away3d.events.MouseEvent3D;
	
	import com.away3d.gloop.events.GameEvent;
	import com.away3d.gloop.hud.elements.InventoryDrawer;
	import com.away3d.gloop.hud.elements.InventoryItemButton;
	import com.away3d.gloop.hud.elements.StarIcon;
	import com.away3d.gloop.level.LevelInventoryItem;
	import com.away3d.gloop.level.LevelProxy;
	
	import flash.display.Sprite;

	public class HUD extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		
		private var _levelProxy : LevelProxy;
		
		private var _stars : Vector.<StarIcon>;
		private var _inventory : InventoryDrawer;
		private var _inventoryButtons : Vector.<InventoryItemButton>;
		
		public function HUD(w : Number, h : Number)
		{
			_w = w;
			_h = h;
			
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
			
			_inventory = new InventoryDrawer(_h - 200);
			_inventory.y = 100;
			addChild(_inventory);
			
			_inventoryButtons = new Vector.<InventoryItemButton>();
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
				var btn : InventoryItemButton;
				var item : LevelInventoryItem;
				
				item = _levelProxy.inventory.items[i];
				btn = new InventoryItemButton(item);
				btn.x = i*60;
				btn.mouseEnabled = true;
				btn.addEventListener(MouseEvent3D.CLICK, onInventoryButtonClick);
				
				addChild(btn);
				_inventoryButtons.push(btn);
			}
		}
		
		
		private function clear() : void
		{
			var btn : InventoryItemButton;
			
			while (btn = _inventoryButtons.pop()) {
				btn.removeEventListener(MouseEvent3D.CLICK, onInventoryButtonClick);
				removeChild(btn);
			}
		}
		
		
		private function onInventoryButtonClick(ev : MouseEvent3D) : void
		{
			var btn : InventoryItemButton;
			
			btn = InventoryItemButton(ev.currentTarget);
			
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