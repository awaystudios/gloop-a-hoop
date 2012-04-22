package com.away3d.gloop.gameobjects
{

	import Box2DAS.Dynamics.ContactEvent;

	import away3d.materials.lightpickers.LightPickerBase;
	
	import com.away3d.gloop.gameobjects.components.MeshComponent;
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	import com.away3d.gloop.level.Level;

	public class DefaultGameObject extends GameObject
	{
		protected var _mode:Boolean;
		protected var _meshComponent : MeshComponent;
		protected var _physics : PhysicsComponent;
		protected var _allowMeshUpdateX:Boolean = true;
		protected var _allowMeshUpdateY:Boolean = true;

		public function DefaultGameObject()
		{
			super();
		}
		
		public override function update(dt:Number):void
		{
			if (_meshComponent && _physics) {
				if( _allowMeshUpdateX ) {
					_meshComponent.mesh.x = _physics.x;
				}
				if( _allowMeshUpdateY ) {
					_meshComponent.mesh.y = -_physics.y;
				}
				_meshComponent.mesh.rotationZ = -physics.rotation;
			}
		}
		
		public function setMode(value:Boolean):void {
			_mode = value;
		}
		
		public function reset():void {
			
		}

		public function onCollidingWithSomethingStart( event:ContactEvent ):void {

		}

		public function onCollidingWithSomethingEnd( event:ContactEvent ):void {

		}
		
		public function onCollidingWithSomethingPreSolve( event:ContactEvent ):void {

		}

		public function onCollidingWithGloopStart(gloop:Gloop, event:ContactEvent = null ):void {

		}
		
		public function onCollidingWithGloopEnd(gloop:Gloop, event:ContactEvent = null ):void {
			
		}

		public function onCollidingWithGloopPreSolve( gloop:Gloop, event:ContactEvent = null ):void {

		}
		
		public function setLightPicker(picker : LightPickerBase) : void
		{
			if (_meshComponent)
				_meshComponent.setLightPicker(picker);
		}
		
		public function get physics():PhysicsComponent {
			return _physics;
		}
		
		public function get meshComponent():MeshComponent {
			return _meshComponent;
		}
		
		public function get debugColor1():uint {
			return 0xff0000;
		}
		
		public function get debugColor2():uint {
			return 0x00ff00;
		}
		
		public function get inEditMode():Boolean {
			return _mode == Level.EDIT_MODE;
		}
	}
}