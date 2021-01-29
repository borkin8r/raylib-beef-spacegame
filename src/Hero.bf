using raylib_beef.Types;

namespace SpaceGame
{
	class Hero : Entity
	{
		public const int cShootDelay = 10; // How many frames to delay between shots
		public const float cMoveSpeed = 4.0f;

		public int mHealth = 1;
		public bool mIsMovingX;
		public int mShootDelay;

		public int mReviveDelay = 0;
		public int mInvincibleDelay = 0;

		public override void Draw()
		{
			if (mReviveDelay > 0)
				return;

			if ((mInvincibleDelay > 0) && ((mInvincibleDelay / 5 % 2 == 0)))
				return;

			float x = mX - 29;
			float y = mY - 41;
			Texture2D texture = Textures.sHero;

			Rectangle srcRect = .(0, 0, texture.width, texture.height);
			Rectangle destRect = .((int32)x, (int32)y, texture.width, texture.height);

			if (mIsMovingX)
			{
				int32 inset = (.)(srcRect.width * 0.09f);
				destRect.x += inset;
				destRect.width -= inset * 2;
			}

			GameApp.DrawTextureRec(texture, srcRect, .((int32)x, (int32)y), Color.WHITE);
		}

		public override void Update()
		{
			if (mReviveDelay > 0)
			{
				if (--mReviveDelay == 0)
					gGameApp.mScore = 0;
				return;
			}

			if (mInvincibleDelay > 0)
				mInvincibleDelay--;

			base.Update();
			if (mShootDelay > 0)
				mShootDelay--;

			if (mHealth < 0)
			{
				gGameApp.ExplodeAt(mX, mY, 1.0f, 0.5f);
				GameApp.PlaySound(Sounds.sExplode);
				gGameApp.mDifficulty = 0;

				mHealth = 1;
				mReviveDelay = 100;
				mInvincibleDelay = 100;
				if (gGameApp.mScore > gGameApp.mHighScore)
				{
					gGameApp.mHighScore = gGameApp.mScore;
				}
			}
		}
	}

	
}
