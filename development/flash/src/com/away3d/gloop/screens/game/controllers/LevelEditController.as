package com.away3d.gloop.screens.game.controllers
{
	import com.away3d.gloop.events.InventoryEvent;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.GameObject;
	import com.away3d.gloop.gameobjects.GameObjectType;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.gameobjects.hoops.HoopType;
	import com.away3d.gloop.gameobjects.hoops.RocketHoop;
	import com.away3d.gloop.gameobjects.hoops.TrampolineHoop;
	import com.away3d.gloop.level.LevelInventoryItem;
	import com.away3d.gloop.level.LevelProxy;

	public class LevelEditController
	{
		private var _levelProxy : LevelProxy;
		
		public function LevelEditController()
		{
		}
		
		
		
		public function activate(levelProxy : LevelProxy) : void
		{
			_levelProxy = levelProxy;
			_levelProxy.inventory.addEventListener(InventoryEvent.ITEM_SELECT, onInventorySelect);
		}
		
		
		public function deactivate() : void
		{
			_levelProxy.removeEventListener(InventoryEvent.ITEM_SELECT, onInventorySelect);
		}
		
		
		
		private function onInventorySelect(ev : InventoryEvent) : void
		{
			if (ev.item.type == GameObjectType.HOOP) {
				var hoop : Hoop;
				
				switch (ev.item.variant) {
					case HoopType.TRAMPOLINE:
						hoop = new TrampolineHoop();
						break;
					case HoopType.ROCKET:
						hoop = new RocketHoop();
						break;
				}
				
				if (hoop) {
					_levelProxy.level.queueHoopForPlacement(hoop);
				}
			}
		}
	}
}