package com.away3d.gloop.gameobjects.components
{
	import away3d.animators.VertexAnimator;
	import away3d.animators.data.VertexAnimation;
	import away3d.animators.data.VertexAnimationMode;
	import away3d.animators.data.VertexAnimationSequence;
	import away3d.animators.data.VertexAnimationState;
	import away3d.arcane;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	
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
		
		public function addSequence(name : String, frames : Array, frameDuration : uint = 200) : void
		{
			var frame : Geometry;
			var seq : VertexAnimationSequence;
			
			seq = new VertexAnimationSequence(name);
			for each (frame in frames) {
				seq.addFrame(frame, frameDuration);
			}
			
			_animator.addSequence(seq);
		}
	}
}