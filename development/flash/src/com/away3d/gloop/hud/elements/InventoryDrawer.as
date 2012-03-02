package com.away3d.gloop.hud.elements
{
	import com.away3d.gloop.level.LevelInventoryItem;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class InventoryDrawer extends Sprite
	{
		private var _h : Number;
		private var _bg : Shape;
		
		private var _items : Vector.<InventoryItemButton>;
		private var _selectedItem : LevelInventoryItem;
		
		public function InventoryDrawer(h : Number)
		{
			super();
			
			_h = h;
			
			init();
		}
		
		
		private function init() : void
		{
			var w : Number;
			var cr : Number;
			var tw : Number;
			var th : Number;
			
			_bg = new Shape();
			_bg.alpha = 0.5;
			_bg.cacheAsBitmap = true;
			addChild(_bg);
			
			w = 140;
			cr = 20; // Curve radius
			tw = 15; // Tab width, excluding curve
			th = 30; // Tab height, excluding curve
			
			//_bg.graphics.lineStyle(5, 0xcccccc, 1);
			_bg.graphics.beginFill(0);
			_bg.graphics.lineTo(w+tw, 0);
			_bg.graphics.curveTo(w+tw+cr, 0, w+tw+cr, cr);
			_bg.graphics.lineTo(w+tw+cr, cr+th);
			_bg.graphics.curveTo(w+tw+cr, cr+th+cr, w+tw, cr+th+cr);
			_bg.graphics.lineTo(w, cr+th+cr);
			_bg.graphics.lineTo(w, _h-cr);
			_bg.graphics.curveTo(w, _h, w-cr, _h);
			_bg.graphics.lineTo(0, _h);
			_bg.graphics.endFill();
			
			_items = new Vector.<InventoryItemButton>();
		}
		
		
		public function get selectedItem() : LevelInventoryItem
		{
			return _selectedItem;
		}
		
		
		public function clear() : void
		{
			var btn : InventoryItemButton;
			
			while (btn = _items.pop()) {
				btn.removeEventListener(MouseEvent.CLICK, onInventoryButtonClick);
				removeChild(btn);
			}
		}
		
		
		public function addItem(item : LevelInventoryItem) : void
		{
			var btn : InventoryItemButton;
			
			btn = new InventoryItemButton(item);
			btn.y = _items.length*60;
			btn.mouseEnabled = true;
			btn.addEventListener(MouseEvent.CLICK, onInventoryButtonClick);
				
			addChild(btn);
			_items.push(btn);
		}
		
		
		private function onInventoryButtonClick(ev : MouseEvent) : void
		{
			var btn : InventoryItemButton;
			
			btn = InventoryItemButton(ev.currentTarget);
			_selectedItem = btn.inventoryItem;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		
	}
}