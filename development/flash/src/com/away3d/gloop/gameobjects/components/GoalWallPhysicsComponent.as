package com.away3d.gloop.gameobjects.components {
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import com.away3d.gloop.gameobjects.DefaultGameObject;
	import com.away3d.gloop.gameobjects.Gloop;
	import com.away3d.gloop.gameobjects.GoalWall;
	import com.away3d.gloop.Settings;
	
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public class GoalWallPhysicsComponent extends WallPhysicsComponent {
		
		public function GoalWallPhysicsComponent(gameObject:DefaultGameObject, offsetX:Number, offsetY:Number, width:Number, height:Number) {
			graphics.beginFill(gameObject.debugColor2);
			graphics.drawRect(offsetX, offsetY, width + Settings.GOALWALL_DETECTOR_WIDTH, height + Settings.GOALWALL_DETECTOR_HEIGHT);
			offsetX += Settings.WALL_PADDING;
			offsetY += Settings.WALL_PADDING;
			width -= 2*Settings.WALL_PADDING;
			height -= 2*Settings.WALL_PADDING;
			super(gameObject, offsetX, offsetY, width, height);
		}
		
		override protected function onBeginContact(e:ContactEvent):void {
			if (e.fixture == b2fixtures[1]) {
				var gloop:Gloop = getGloop(e.other);
				if (!gloop) return;
				GoalWall(_gameObject).onGloopEnterSensor(gloop);
				return;
			}
			
			super.onBeginContact(e);
		}
		
		override protected function onEndContact(e:ContactEvent):void {
			if (e.fixture == b2fixtures[1]) {
				var gloop:Gloop = getGloop(e.other);
				if (!gloop) return;
				GoalWall(_gameObject).onGloopExitSensor(gloop);
				return;
			}
			
			super.onEndContact(e);
		}
		
		override public function shapes():void {
			super.shapes();
			
			var w:Number = _width + Settings.GOALWALL_DETECTOR_WIDTH;
			var h:Number = _height + Settings.GOALWALL_DETECTOR_HEIGHT;
			
			poly([
				[_offsetX, 		_offsetY],
				[_offsetX + w,	_offsetY],
				[_offsetX + w, 	_offsetY + h],
				[_offsetX, 		_offsetY + h],
			]);	
		}
		
		override public function create():void {
			super.create();
			setCollisionGroup(GLOOP_SENSOR, b2fixtures[1]);
			b2fixtures[1].SetSensor(true);
		}
		
	}

}