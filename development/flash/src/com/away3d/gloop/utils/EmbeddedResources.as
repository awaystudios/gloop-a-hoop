package com.away3d.gloop.utils
{
	public class EmbeddedResources
	{
		// Gloop
		[Embed('/../assets/gloop/flying/flying.awd', mimeType='application/octet-stream')]
		public static var FlyingAWDAsset : Class;
		
		[Embed('/../assets/gloop/splat/splat.3ds', mimeType='application/octet-stream')]
		public static var GloopSplat3DSAsset : Class;
		
		[Embed('/../assets/gloop/splat/diff.png')]
		public static var GloopSplatDiffusePNGAsset : Class;
		
		[Embed("/../assets/gloop/diff.png")]
		public static var GloopDiffusePNGAsset : Class;

		[Embed("/../assets/gloop/spec.png")]
		public static var GloopSpecularPNGAsset : Class;

		
		// Cannon
		[Embed('/../assets/cannon/cannon.3ds', mimeType='application/octet-stream')]
		public static var Cannon3DSAsset : Class;
		
		[Embed("/../assets/cannon/diff.png")]
		public static var CannonDiffusePNGAsset : Class;
		
		
		// Target
		[Embed("/../assets/props/target/target.3ds", mimeType="application/octet-stream")]
		public static var Target3DSAsset : Class;
		
		[Embed("/../assets/props/target/diff.png")]
		public static var TargetDiffusePNGAsset : Class;
		
		
		// Misc props
		[Embed("/../assets/props/fan/fan.3ds", mimeType="application/octet-stream")]
		public static var Fan3DSAsset : Class;
		
		[Embed("/../assets/props/button/button.3ds", mimeType="application/octet-stream")]
		public static var Button3DSAsset : Class;
		
		[Embed("/../assets/props/star/star.3ds", mimeType="application/octet-stream")]
		public static var Star3DSAsset : Class;
		
		[Embed("/../assets/props/hoop/hoop.3ds", mimeType="application/octet-stream")]
		public static var Hoop3DSAsset : Class;
		
		[Embed("/../assets/props/box/box.awd", mimeType="application/octet-stream")]
		public static var BoxAWDAsset : Class;
	}
}