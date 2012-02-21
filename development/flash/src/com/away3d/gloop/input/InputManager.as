package com.away3d.gloop.input {
	import away3d.containers.View3D;
	import Box2DAS.Common.V2;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.gameobjects.Wall;
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
		private var _targetHoop:Hoop;
		
		private static const CLICK_TIME:uint = 250;
		private static const CLICK_DISTANCE_THRESHOLD:uint = 500;
		
		public function InputManager(view:View3D, level:Level) {
			super(view);
			_level = level;
		}
		
		override protected function onViewMouseDown(e:MouseEvent):void {
			super.onViewMouseDown(e);
			_mouseDownTime = getTimer();
			super.update(); // force update of mouse position to get the proper target
			_targetHoop = getNearestHoop(mouseX, mouseY);
			if (_targetHoop) _targetHoop.onDragStart(mouseX, mouseY);
		}
		
		override public function update():void {
			if (!_mouseDown) return; // if there's no touch, there's no sense in updating
			super.update();
			if (_targetHoop) _targetHoop.onDragUpdate(mouseX, mouseY);
		}
		
		override protected function onViewMouseUp(e:MouseEvent):void {
			super.onViewMouseUp(e);
			var clickDuration:Number = getTimer() - _mouseDownTime;
			
			// deal with click if duration was short enough
			if (_targetHoop && clickDuration < CLICK_TIME) _targetHoop.onClick(mouseX, mouseY);
			// end dragging
			if (_targetHoop) _targetHoop.onDragStart(mouseX, mouseY);
			
			_targetHoop = null;
		}
		
		/**
		 * Returns the nearest hoop to the supplied coordinates assuming it is closer than CLICK_DISTANCE_THRESHOLD
		 * @param	mouseX
		 * @param	mousey
		 * @return
		 */
		private function getNearestHoop(mouseX:Number, mousey:Number):Hoop {
			var hoop:Hoop;
			var nearest:Hoop;
			var dist:Number = 0;
			var nearestDist:Number = CLICK_DISTANCE_THRESHOLD;
			var mousePos:Point = new Point(mouseX, mouseY);
			var hoopPos:Point = new Point;
			
			for (var i:int = 0; i < _level.objects.length; i++) {
				hoop = _level.objects[i] as Hoop;
				if (!hoop) continue;
				
				hoopPos.x = hoop.physics.x;
				hoopPos.y = hoop.physics.y;
				
				dist = Point.distance(mousePos, hoopPos);
				
				if (dist < nearestDist) {
					nearestDist = dist;
					nearest = hoop;
				}
			}
			
			return nearest;
		}
		
	}

}