package com.away3d.gloop.gameobjects.components
{
	import away3d.animators.VertexAnimator;
	import away3d.animators.data.VertexAnimation;
	import away3d.animators.data.VertexAnimationMode;
	import away3d.animators.data.VertexAnimationSequence;
	import away3d.animators.data.VertexAnimationState;
	import away3d.arcane;
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.core.managers.Stage3DProxy;
	import away3d.entities.Mesh;

	import com.away3d.gloop.screens.game.GameScreen;

	import flash.display3D.IndexBuffer3D;

	import flash.display3D.VertexBuffer3D;

	use namespace arcane;

	public class VertexAnimationComponent
	{
		private var _mesh : Mesh;
		private var _animator : VertexAnimator;
		
		public function VertexAnimationComponent(mesh : Mesh)
		{
			var state : VertexAnimationState;
			
			_mesh = mesh;
			_mesh.geometry.animation = new VertexAnimation(2, VertexAnimationMode.ABSOLUTE);
			
			state = VertexAnimationState(_mesh.animationState);
			_animator = new VertexAnimator(state);
		}
		
		
		public function play(sequenceName : String) : void
		{
			_animator.play(sequenceName);
		}
		
		public function stop() : void
		{
			_animator.stop();
		}
		
		public function addSequence(name : String, frames : Array, frameDuration : uint = 200, loop : Boolean = true) : void
		{
			var frame : Geometry;
			var seq : VertexAnimationSequence;
			
			seq = new VertexAnimationSequence(name);
			seq.looping = loop;
			for each (frame in frames) {
				seq.addFrame(frame, frameDuration);
				// avoid hick ups during game play ( assumes 1 subgeom per geom )
//				var vertexDummy:VertexBuffer3D = frame.subGeometries[ 0 ].getVertexBuffer( GameScreen.instance.view.stage3DProxy );
//				var indexDummy:IndexBuffer3D = frame.subGeometries[ 0 ].getIndexBuffer( GameScreen.instance.view.stage3DProxy );
//				GameScreen.instance.view.stage3DProxy._context3D.setVertexBufferAt( 0, vertexDummy );
			}
			
			_animator.addSequence(seq);
//			_animator.play(name);
		}
	}
}