package com.away3d.gloop.input {
	import away3d.containers.View3D;
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.level.Level;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class InputManager extends MouseManager {
		
		private var _level:Level;
		private var _mouseDownTime:Number = 0;
		private var _mouseUpTime:Number = 0;
		private var _target:DefaultGameObject;
		
		private static const CLICK_TIME:uint = 150;
		
		public function InputManager(view:View3D, level:Level) {
			super(view);
			_level = level;
		}
		
		override protected function onViewMouseDown(e:MouseEvent):void {
			super.onViewMouseDown(e);
			_mouseDownTime = getTimer();
			pickTarget();
		}
		
		override protected function onViewMouseUp(e:MouseEvent):void {
			super.onViewMouseUp(e);
			_mouseUpTime = getTimer();
			var clickDuration:Number = _mouseUpTime - _mouseDownTime;
			if (clickDuration < CLICK_TIME) {
				
				var hoop:Hoop = _target as Hoop;
				if (hoop) {
					var pos:V2 = hoop.physics.b2body.GetPosition();
					var angle:Number = hoop.physics.b2body.GetAngle();
					hoop.physics.b2body.SetTransform(pos, angle + 45);
				}
				
			}
		}
		
		private function pickTarget():void {
			var nearest:DefaultGameObject;
			var dist:Number = 0;
			var nearestDist:Number = Number.MAX_VALUE;
			var mousePos:Point = new Point(mouseX, mouseY);
			var objectPos:Point = new Point;
			
			for each (var go:DefaultGameObject in _level.objects) {
				if (!go.interactive) continue;
				objectPos.x = go.physics.x;
				objectPos.y = go.physics.y;
				
				trace(mousePos, objectPos);
				
				dist = Point.distance(mousePos, objectPos);
				
				if (dist < nearestDist) {
					nearestDist = dist;
					nearest = go;
				}
			}
			
			_target = nearest;
		}
		
	}

}