package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	
	import com.away3d.gloop.events.InventoryEvent;
	import com.away3d.gloop.gameobjects.hoops.HoopType;
	import com.away3d.gloop.level.LevelInventoryItem;
	import com.away3d.gloop.lib.hoops.RocketHoopBitmap;
	import com.away3d.gloop.lib.hoops.SpringHoopBitmap;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class InventoryItemButton extends Sprite
	{
		private var _item : LevelInventoryItem;
		
		public function InventoryItemButton(item : LevelInventoryItem)
		{
			super();
			
			_item = item;
			
			init();
		}
		
		private  function init() : void
		{
			var mtx : Matrix;
			var bmp : BitmapData;
			
			switch (_item.variant) {
				case HoopType.ROCKET:
					bmp = new RocketHoopBitmap();
					break;
				case HoopType.TRAMPOLINE:
					bmp = new SpringHoopBitmap();
					break;
			}
			
			mtx = new Matrix(1, 0, 0, 1, -bmp.width/2, -bmp.height/2);
			graphics.beginBitmapFill(bmp, mtx, false, true);
			graphics.drawRect(-bmp.width/2, -bmp.height/2, bmp.width, bmp.height);
			
			_item.addEventListener(InventoryEvent.ITEM_CHANGE, onItemChange);
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