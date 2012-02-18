package com.away3d.gloop.screens
{
	import away3d.containers.View3D;
	
	import com.away3d.gloop.level.Level;
	import com.away3d.gloop.level.LevelDatabase;
	
	import flash.events.Event;
	
	import wck.WCK;

	public class GameScreen extends ScreenBase
	{
		private var _db : LevelDatabase;
		private var _level : Level;
		
		private var _doc : WCK;
		private var _view : View3D;
		
		
		public function GameScreen(db : LevelDatabase)
		{
			super();
			
			_db = db;
		}
		
		
		protected override function initScreen():void
		{
			_doc = new WCK();
			_doc.x = 80;
			_doc.y = 80;
			_doc.scaleX = 0.2;
			_doc.scaleY = 0.2;
			addChild(_doc);
			
			_view = new View3D();
			_view.antiAlias = 4;
			addChild(_view);
		}
		
		
		public override function activate() : void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_level = _db.selectedProxy.level;
			_doc.addChild(_level.world);
			_view.scene = _level.scene;
		}
		
		
		public override function deactivate() : void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function onEnterFrame(ev : Event) : void
		{
			if (_level)
				_level.update();
			
			_view.camera.x = stage.mouseX - stage.stageWidth/2;
			_view.camera.y = stage.mouseY - stage.stageHeight/2;
			_view.render();
		}
	}
}