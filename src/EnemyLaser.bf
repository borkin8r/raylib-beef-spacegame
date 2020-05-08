using raylib_beef.Types;

namespace SpaceGame
{
	class EnemyLaser : EnemyProjectile
	{
		public float mVelX;
		public float mVelY;

		public override void Update()
		{
			base.Update();

			mX += mVelX;
			mY += mVelY;

			if (IsOffscreen(16, 16))
				mIsDeleting = true;
		}

		public override void Draw()
		{
			GameApp.DrawTexture(Textures.sEnemyLaser, (.)mX - 10, (.)mY - 13, Color.WHITE);
		}
	}
}
