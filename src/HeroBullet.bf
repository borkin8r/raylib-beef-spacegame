using raylib_beef.Types;

namespace SpaceGame
{
	class HeroBullet : Entity
	{
		public override void Update()
		{
			mY -= 8.0f;
			if (mY < -16)
				mIsDeleting = true;

			for (let entity in gGameApp.mEntities)
			{
				if (let enemy = entity as Enemy)
				{
					if (GameApp.CheckCollisionPointRec(.((mX - entity.mX), (mY - entity.mY)), enemy.mBoundingBox) && (enemy.mHealth > 0))
					{
						mIsDeleting = true;
						enemy.mHealth--;
						
						gGameApp.ExplodeAt(mX, mY, 0.25f, 1.25f);
						GameApp.PlaySound(Sounds.sExplode);

						break;
					}
				}
			}
		}

		public override void Draw()
		{
			GameApp.DrawTexture(Textures.sHeroLaser, (.)mX - 8, (.)mY - 9, Color.WHITE);
		}
	}
}
