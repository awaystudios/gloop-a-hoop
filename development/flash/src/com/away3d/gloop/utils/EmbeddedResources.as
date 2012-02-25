package com.away3d.gloop.utils
{
	public class EmbeddedResources
	{
		[Embed('/../assets/gloop/flying/flying.awd', mimeType='application/octet-stream')]
		public static var FlyingAWDAsset : Class;
		
		[Embed('/../assets/cannon/cannon.3ds', mimeType='application/octet-stream')]
		public static var Cannon3DSAsset : Class;
		
		[Embed("/../assets/gloop/diff.png")]
		public static var GloopDiffusePNGAsset : Class;

		[Embed("/../assets/gloop/spec.png")]
		public static var GloopSpecularPNGAsset : Class;

	}
}