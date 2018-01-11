Shader "MJ/NightVisionEffectShader" 
{
	Properties 
	{
		_MainTex("Base (RGB)", 2D) = "white"{}
		_VignetteTex("Vignette Texture", 2D) = "white"{}
		_ScaleLineTex("Scan Line Texture", 2D) = "white"{}
		_NoiseTex("Noise Texture", 2D) = "white"{}
		_NoiseXSpeed("Noise X Speed", float) = 100.0
		_NoiseXSpeed("Noise Y Speed", float) = 100.0
		_ScanLineTileAmount("Scan Line Tile Amount", float) = 4
		_NightVisionColor("Night Vision Color")	
			
	}
	SubShader 
	{

	}
	FallBack "Diffuse"
}
