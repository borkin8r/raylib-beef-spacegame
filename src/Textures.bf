using System;
using raylib_beef.Types;
using raylib_beef;
using System.Collections;

namespace SpaceGame
{
	static class Textures
	{
		public static Texture2D sBkg;
		public static Texture2D sSpaceTexture;
		public static Texture2D sExplosionTexture;
		public static Texture2D sHero;
		public static Texture2D sHeroLaser;
		public static Texture2D sEnemySkirmisher;
		public static Texture2D sEnemyBomber;
		public static Texture2D sEnemyGoliath;
		public static Texture2D sEnemyLaser;
		public static Texture2D sEnemyBomb;
		public static Texture2D sEnemyPhaser;

		static List<Texture2D> sTextures = new .() ~ delete _;

		public static Result<Texture2D> Load(StringView fileName)
		{
			Texture2D Texture = Raylib.LoadTexture(fileName.ToScopeCStr!()); //TODO: check for failure?	need delete?
			sTextures.Add(Texture);
			return Texture;
		}

		public static void Dispose()
		{
			ClearAndDeleteItems(sTextures);
		}

		public static Result<void> Init()
		{
			sBkg = Try!(Load("images/space.jpg"));
			sSpaceTexture = Try!(Load("images/space.jpg"));
			sExplosionTexture = Try!(Load("images/explosion.png"));

			sHero = Try!(Load("images/Ship01.png"));
			sHeroLaser = Try!(Load("images/Bullet03.png"));

			sEnemySkirmisher = Try!(Load("images/Ship02.png"));
			sEnemyBomber = Try!(Load("images/Ship03.png"));
			sEnemyGoliath = Try!(Load("images/Ship04.png"));
			sEnemyLaser = Try!(Load("images/Bullet02.png"));
			sEnemyBomb = Try!(Load("images/Bullet01.png"));
			sEnemyPhaser = Try!(Load("images/Bullet04.png"));
			return .Ok;
		}
	}
}
