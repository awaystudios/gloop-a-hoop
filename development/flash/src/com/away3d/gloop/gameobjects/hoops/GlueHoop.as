package com.away3d.gloop.gameobjects.hoops
{
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.components.GloopLauncherComponent;
	import com.away3d.gloop.gameobjects.events.GameObjectEvent;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.Settings;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GlueHoop extends Hoop
	{
		
		private var _launcher:GloopLauncherComponent;
		
		public function GlueHoop(worldX : Number = 0, worldY : Number = 0, rotation : Number = 0)
		{
			super(worldX, worldY, rotation);
			_rotatable = false;
			_launcher = new GloopLauncherComponent(this);
		}
		
		override public function reset():void {
			super.reset();
			_launcher.reset();
		}
		
		public override function onCollidingWithGloopStart(gloop : Gloop) : void
		{
			super.onCollidingWithGloopStart(gloop);
			_launcher.catchGloop(gloop);
		}
		
		override public function onDragUpdate(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				_launcher.onDragUpdate(mouseX, mouseY);
				return;
			}
			
			super.onDragUpdate(mouseX, mouseY); 
		}
		
		override public function onDragEnd(mouseX:Number, mouseY:Number):void {
			if (_launcher.gloop) {
				_launcher.onDragEnd(mouseX, mouseY);
				return;
			}
			
			super.onDragEnd(mouseX, mouseY);
		}
		
		override public function update(dt : Number) : void
		{
			super.update(dt);
			_launcher.update(dt);
		}
		
		override public function get debugColor1() : uint
		{
			return 0x5F9E30;
		}
		
		override public function get debugColor2() : uint
		{
			return 0x436F22;
		}
	
	}

}