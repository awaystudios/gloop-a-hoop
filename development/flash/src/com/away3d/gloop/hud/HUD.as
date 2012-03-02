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
	import flash.events.Event;

	public class HUD extends Sprite
	{
		private var _w : Number;
		private var _h : Number;
		
		private var _levelProxy : LevelProxy;
		
		private var _stars : Vector.<StarIcon>;
		private var _inventory : InventoryDrawer;
		
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
			_inventory.addEventListener(Event.SELECT, onInventorySelect);
			addChild(_inventory);
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
				var item : LevelInventoryItem;
				
				item = _levelProxy.inventory.items[i];
				_inventory.addItem(item);
			}
		}
		
		
		private function clear() : void
		{
			_inventory.clear();
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
			
		private function onInventorySelect(ev : Event) : void
		{
			_levelProxy.inventory.select(_inventory.selectedItem);
		}
	}
}