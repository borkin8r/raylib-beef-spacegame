using raylib_beef.Types;

namespace SpaceGame
{
	class EnemyProjectile : Entity
	{
		public override void Update()
		{
			if (gGameApp.mHero.mInvincibleDelay > 0)
				return;

			Rectangle heroBoundingBox = .(-30, -30, 60, 60);
			if (GameApp.CheckCollisionPointRec(.((.)(mX - gGameApp.mHero.mX), (.)(mY - gGameApp.mHero.mY)), heroBoundingBox))
			{
				gGameApp.ExplodeAt(mX, mY, 0.25f, 1.25f);
				GameApp.PlaySound(Sounds.sExplode);
				gGameApp.mHero.mHealth--;
			}
		}
	}
}
