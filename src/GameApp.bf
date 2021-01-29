using System;
using raylib_beef;
using raylib_beef.Types;
using raylib_beef.Enums;
using System.Collections;

namespace SpaceGame
{
	static
	{
		public static GameApp gGameApp;
	}

	class GameApp : Raylib
	{
		public List<Entity> mEntities = new List<Entity>() ~ DeleteContainerAndItems!(_);
		public Hero mHero;
		public int mScore;
		public int mHighScore;
		public float mDifficulty;
		public Random mRand = new Random() ~ delete _;
		Font mFont;
		float mBkgPos;
		int mEmptyUpdates;
		bool mHasMoved;
		bool mHasShot;
		public const int SCREENWIDTH = 1024;
		public const int SCREENHEIGHT = 768;

		public this()
		{
			gGameApp = this;
		}

		public ~this()
		{
			Textures.Dispose();
			Sounds.Dispose();		   
		}

		public void Init()
		{
			InitWindow(SCREENWIDTH, SCREENHEIGHT, "raylibeef Space Game!");
			// SetTargetFPS call after init, before loading texture.
			SetTargetFPS(60); // also include example of timer setup?
			Textures.Init();
			Sounds.Init();
			mFont = LoadFontEx("zorque.ttf", 24, null, 250);
			SpawnHero();
		}

		public void DrawString(float x, float y, String str, Color color, bool centerX = false)
		{
			var x;

			if (centerX)
				x -= GetScreenWidth() / 2;

			let position = Vector2(x, y);
			DrawTextEx(mFont, str, position, mFont.baseSize, 2, color);
		}

		public void Draw()
		{
			BeginDrawing();
			DrawTexture(Textures.sSpaceTexture, 0, (.) mBkgPos - 1024, Color.WHITE);	 //can't use float?
			DrawTexture(Textures.sSpaceTexture, 0, (.) mBkgPos, Color.WHITE);

			for (var entity in mEntities)
				entity.Draw();

			DrawString(8, 24, scope String()..AppendF("SCORE: {}", mScore), .(64, 255, 64, 255));
			DrawString(8, 4, scope String()..AppendF("HIGHSCORE: {}", mHighScore), .(64, 255, 64, 255));

			if ((!mHasMoved) || (!mHasShot))
				DrawString(SCREENWIDTH / 2, 200, "Use cursor keys to move and Space to fire", .(255, 255, 255, 255), true);
			EndDrawing();
		}

		public void ExplodeAt(float x, float y, float sizeScale, float speedScale)
		{
			let explosion = new Explosion();
			explosion.mSizeScale = sizeScale;
			explosion.mSpeedScale = speedScale;
			explosion.mX = x;
			explosion.mY = y;
			mEntities.Add(explosion);
		}

		public void AddEntity(Entity entity)
		{
			mEntities.Add(entity);
		}

		void HandleInputs()
		{
			float deltaX = 0;
			float deltaY = 0;
			float moveSpeed = Hero.cMoveSpeed;
			if (IsKeyDown(.KEY_LEFT))
				deltaX -= moveSpeed;
			if (IsKeyDown(.KEY_RIGHT))
				deltaX += moveSpeed;

			if (IsKeyDown(.KEY_UP))
				deltaY -= moveSpeed;
			if (IsKeyDown(.KEY_DOWN))
				deltaY += moveSpeed;

			if ((deltaX != 0) || (deltaY != 0))
			{
				mHero.mX = Math.Clamp(mHero.mX + deltaX, 10, SCREENWIDTH - 10);
				mHero.mY = Math.Clamp(mHero.mY + deltaY, 10, SCREENHEIGHT - 10);
				mHasMoved = true;
			}
			mHero.mIsMovingX = deltaX != 0;

			if ((IsKeyDown(.KEY_SPACE)) && (mHero.mShootDelay == 0))  //TODO multiplier for not missing
			{
				mHasShot = true;
				mHero.mShootDelay = Hero.cShootDelay;
				let bullet = new HeroBullet();
				bullet.mX = mHero.mX;
				bullet.mY = mHero.mY - 50;
				AddEntity(bullet);
				PlaySound(Sounds.sLaser);
			}
		}

		void SpawnHero()
		{
			mHero = new Hero();
			AddEntity(mHero);
			mHero.mY = 650;
			mHero.mX = 512;
		}

		void SpawnSkirmisher()
		{
			let spawner = new EnemySkirmisher.Spawner();
			spawner.mLeftSide = mRand.NextDouble() < 0.5;
			spawner.mY = ((float)mRand.NextDouble() * 0.5f + 0.25f) * SCREENHEIGHT;
			AddEntity(spawner);
		}

		void SpawnGoliath()
		{
			let enemy = new EnemyGolaith();
			enemy.mX = ((float)mRand.NextDouble() * 0.5f + 0.25f) * SCREENWIDTH;
			enemy.mY = -300;
			AddEntity(enemy);
		}

		void SpawnEnemies()
		{
			bool hasEnemies = false;
			for (var entity in mEntities)
				if (entity is Enemy)
					hasEnemies = true;
			if (hasEnemies)
				mEmptyUpdates = 0;
			else
				mEmptyUpdates++;

			float spawnScale = 0.4f + (mEmptyUpdates * 0.025f);
			spawnScale += mDifficulty;

			if (mRand.NextDouble() < 0.002f * spawnScale)
				SpawnSkirmisher();

			if (mRand.NextDouble() < 0.0005f * spawnScale)
				SpawnGoliath();
		}

		public void Update()
		{

			HandleInputs();
			SpawnEnemies();

			// Make the game harder over time
			mDifficulty += 0.0001f;

			// Scroll the background
			mBkgPos += 0.6f;
			if (mBkgPos > 1024)
				mBkgPos -= 1024;

			for (var entity in mEntities)
			{
				entity.mUpdateCnt++;
				entity.Update();
				if (entity.mIsDeleting)
				{
					// '@entity' refers to the enumerator itself
	                @entity.Remove();
					delete entity;
				}
			}
		}

		public void Run() {
			

			while(!WindowShouldClose()) {
				HandleInputs();
				Update();
				Draw();
			}
		}
	}
}
