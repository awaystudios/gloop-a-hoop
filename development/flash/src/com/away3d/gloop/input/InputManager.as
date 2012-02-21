package com.away3d.gloop.input {
	import Box2DAS.Common.V2;
	
	import away3d.containers.View3D;
	
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Wall;
	import com.away3d.gloop.gameobjects.hoops.Hoop;
	import com.away3d.gloop.level.Level;
	
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
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
		
		private var _prevViewMouseX : Number;
		private var _prevViewMouseY : Number;
		
		private var _panX : Number;
		private var _panY : Number;
		private var _zoom : Number;
		
		private var _zooming : Boolean;
		private var _panning : Boolean;
		
		
		private static const CLICK_TIME:uint = 250;
		private static const CLICK_DISTANCE_THRESHOLD:uint = 50;
		
		public function InputManager(view:View3D, level:Level) {
			super(view);
			_level = level;
			
			_view.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onPinch);
			_view.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		
		public function get panX() : Number
		{
			return _panX;
		}
		
		
		public function get panY() : Number
		{
			return _panY;
		}
		
		
		public function get zoom() : Number
		{
			return _zoom;
		}
		
		
		public function reset() : void
		{
			_zoom = 1;
			_panX = 0;
			_panY = 0;
		}
		
		
		
		override public function update():void {
			if (!_mouseDown) 
				return; // if there's no touch, there's no sense in updating
			
			super.update();
			
			if (_targetHoop) 
				_targetHoop.onDragUpdate(mouseX, mouseY);
			
			if (_panning && !_zooming) {
				_panX -= (_view.mouseX - _prevViewMouseX);
				_panY += (_view.mouseY - _prevViewMouseY);
			}
			
			_prevViewMouseX = _view.mouseX;
			_prevViewMouseY = _view.mouseY;
		}
		
		
		
		
		private function onPinch(e : TransformGestureEvent) : void
		{
			if (!_targetHoop) {
				_zooming = true;
				_zoom *= (e.scaleX + e.scaleY) * 0.5;
			} 
		}
		
		private function onMouseWheel(e : MouseEvent) : void
		{
			_zoom /= 1 - e.delta * 0.01;
		}
		
		override protected function onViewMouseDown(e:MouseEvent):void {
			super.onViewMouseDown(e);
			_mouseDownTime = getTimer();
			super.update(); // force update of mouse position to get the proper target
			_targetHoop = getNearestHoop(mouseX, mouseY);
			if (_targetHoop) {
				_targetHoop.onDragStart(mouseX, mouseY);
			}
			else {
				_panning = true;
			}
			
			_prevViewMouseX = _view.mouseX;
			_prevViewMouseY = _view.mouseY;
		}
		
		
		override protected function onViewMouseUp(e:MouseEvent):void {
			super.onViewMouseUp(e);
			var clickDuration:Number = getTimer() - _mouseDownTime;
			
			// deal with click if duration was short enough
			if (_targetHoop && clickDuration < CLICK_TIME) _targetHoop.onClick(mouseX, mouseY);
			// end dragging
			if (_targetHoop) _targetHoop.onDragEnd(mouseX, mouseY);
			
			_targetHoop = null;
			_panning = false;
			_zooming = false;
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