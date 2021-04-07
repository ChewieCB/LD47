shader_type canvas_item;
render_mode unshaded;

 //Get texture and a key that we want as transparent
uniform vec4 GlowColor : hint_color;
uniform float OutlineWidth : hint_range(0.0, 4.0);
 
void fragment()
{
	vec2 size = vec2(OutlineWidth) / vec2(textureSize(TEXTURE, 0));
   
    vec4 sprite_color = texture(TEXTURE, UV);
   
    float alpha = sprite_color.a;
    alpha += texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    alpha += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
    alpha += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
   
    vec3 final_color = mix(GlowColor.rgb, sprite_color.rgb, sprite_color.a);
	COLOR = vec4(final_color, clamp(alpha, 0.0, 1.0));
}