shader_type spatial;
//render_mode cull_disabled;

uniform float grid_width = 1.0; // 格子的绝对宽度（单位：米）
uniform vec4 color_a = vec4(0.8, 0.8, 0.8, 1.0);
uniform vec4 color_b = vec4(0.2, 0.2, 0.2, 1.0);

// 传递世界坐标的XZ平面
varying vec3 world_pos;

void vertex() {
    // 计算顶点在世界空间中的位置
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    // 使用世界坐标的XZ平面（忽略高度Y）

    // 根据绝对宽度缩放坐标
    vec3 grid_coord = world_pos / grid_width;

    // 计算格子位置
    vec3 grid_pos = floor(grid_coord);
    float checker = mod(grid_pos.x + grid_pos.y + grid_pos.z, 2.0);

    // 根据 checker 的值选择颜色
    ALBEDO = (checker < 1.0) ? color_a.rgb : color_b.rgb;
}