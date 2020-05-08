using raylib_beef.Types;
using raylib_beef;

namespace SpaceGame
{
	class Explosion : Entity
	{
		public float mSizeScale;
		public float mSpeedScale;

		int32 Frame
		{
			get
			{
				return (int32)(mSpeedScale * mUpdateCnt);
			}
		}

		public override void Update()
		{
			if (Frame == 42)
				mIsDeleting = true;
		}

		public override void Draw()
		{
			//using (g.PushScale(mSizeScale, mSizeScale))
			//gGameApp.Draw(Images.sExplosion[Frame / 6, Frame % 6], -64, -64);

			let texture = Textures.sExplosionTexture;
			float x = mX - (65 * mSizeScale);
			float y = mY - (65 * mSizeScale);

			Rectangle srcRect = .((Frame % 6) * 130, (Frame / 6) * 130, 130, 130);
			Rectangle destRect = .((int32)x, (int32)y, (int32)(mSizeScale * 130), (int32)(mSizeScale * 130));
			Raylib.DrawTexturePro(texture, srcRect, destRect, .(x, y), 0, Color.BLANK);
		}
	}
}
