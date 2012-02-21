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
		
		private var _dragTargetStart:Point;
		private var _dragStartOffset:Point;
		
		private static const CLICK_TIME:uint = 250;
		private static const CLICK_DISTANCE_THRESHOLD:uint = 500;
		
		public function InputManager(view:View3D, level:Level) {
			super(view);
			_dragTargetStart = new Point;
			_dragStartOffset = new Point;
			_level = level;
		}
		
		override public function update():void {
			if (!_mouseDown) return; // if there's no touch, there's no sense in updating
			super.update();
			if (_target) drag(_target);
		}
		
		override protected function onViewMouseDown(e:MouseEvent):void {
			super.onViewMouseDown(e);
			_mouseDownTime = getTimer();
			super.update(); // force update of mouse position to get the proper target
			pickTarget();
		}
		
		override protected function onViewMouseUp(e:MouseEvent):void {
			super.onViewMouseUp(e);
			_mouseUpTime = getTimer();
			var clickDuration:Number = _mouseUpTime - _mouseDownTime;
			if (_target && clickDuration < CLICK_TIME) {
				click(_target);
			}
		}
		
		private function pickTarget():void {
			var nearest:DefaultGameObject;
			var dist:Number = 0;
			var nearestDist:Number = CLICK_DISTANCE_THRESHOLD;
			var mousePos:Point = new Point(mouseX, mouseY);
			var objectPos:Point = new Point;
			
			for each (var go:DefaultGameObject in _level.objects) {
				if (!go.interactive) continue;
				objectPos.x = go.physics.x;
				objectPos.y = go.physics.y;
				
				dist = Point.distance(mousePos, objectPos);
				
				if (dist < nearestDist) {
					nearestDist = dist;
					nearest = go;
				}
			}
			
			_target = nearest;
		}
		
		private function click(target:DefaultGameObject):void {
			var hoop:Hoop = target as Hoop;
			if (hoop && hoop.rotatable) {
				var pos:V2 = hoop.physics.b2body.GetPosition();
				var angle:Number = hoop.physics.b2body.GetAngle();
				hoop.physics.b2body.SetTransform(pos, angle + 45 / 180 * Math.PI);
				hoop.physics.updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
			}
		}
		
		private function drag(target:DefaultGameObject):void {
			var hoop:Hoop = target as Hoop;
			if (hoop && hoop.draggable) {
				var pos:V2 = new V2(Math.round(mouseX / _level.gridSize) * _level.gridSize, Math.round(mouseY / _level.gridSize) * _level.gridSize);
				
				// transform point into physics coord space
				pos.x /= 60;
				pos.y /= 60;
				
				var angle:Number = hoop.physics.b2body.GetAngle();
				hoop.physics.b2body.SetTransform(pos, angle);
				hoop.physics.updateBodyMatrix(null); // updates the 2d view, the 3d will update the next frame
			}
		}
		
	}

}